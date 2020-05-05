defmodule ColonelKurtz.BlockType do
  defmacro __using__(opts) do
    quote do
      use Ecto.Schema
      @primary_key {:block_id, :binary_id, autogenerate: false}

      import unquote(__MODULE__)
      import Ecto.Changeset
      import ColonelKurtz.Validation, only: [validate_blocks: 3]

      alias ColonelKurtz.ValidatableBlock
      alias ColonelKurtz.EctoHelpers
      alias ColonelKurtz.BlockTypes
      alias ColonelKurtz.EctoBlocks

      @before_compile unquote(__MODULE__)
      @after_compile unquote(__MODULE__)

      # A BlockType has a set of explicitly defined attributes (`block.content`)
      @attributes []
      @block_attributes [:block_id, :type, :content, :blocks]
      @block_type unquote(opts[:type])

      @content_module Module.concat(__MODULE__, Content)

      @derive [
        ValidatableBlock,
        {Jason.Encoder, only: @block_attributes}
      ]
      embedded_schema do
        field :type, :string
        field :blocks, EctoBlocks
        embeds_one :content, @content_module
      end

      def from_map(%{type: @block_type, content: content, blocks: blocks} = attrs) do
        struct!(__MODULE__,
          block_id: Map.get(attrs, :block_id) || Ecto.UUID.generate(),
          type: @block_type,
          content: @content_module.from_map(content_attributes(content)),
          blocks: blocks || []
        )
      end

      # The block's content comes in as a map with string keys that needs to be
      # transformed to have atom keys, but also may be overridden to support
      # use cases for computed/transformed/rehydrated data.
      def content_attributes(params) do
        attributes_from_params(params)
      end

      defoverridable content_attributes: 1

      # In the case that a caller wants to override `content_attributes/1` they
      # still have access to this helper method to get the attributes from params
      def attributes_from_params(params) do
        Enum.reduce(schema_keys(), %{}, fn key, acc ->
          Map.put(acc, key, Map.get(params, Atom.to_string(key), Map.get(params, key)))
        end)
      end

      def changeset(block, params) do
        changeset =
          struct(__MODULE__)
          |> cast(params, [:block_id, :type, :blocks])
          |> cast_embed(:content)
          |> lift_content_errors()
          |> validate_blocks(:blocks, lift_errors: false)

        ValidatableBlock.validate(block, changeset)
      end

      def lift_content_errors(%{changes: %{content: %{errors: errors}}} = changeset)
          when is_list(errors) do
        Enum.reduce(errors, changeset, fn {key, {message, opts}}, acc ->
          acc
          |> Map.put(:valid?, false)
          |> add_error(key, EctoHelpers.format_error(message, opts), opts)
        end)
      end

      def lift_content_errors(changeset), do: changeset

      def validate(_block, changeset) do
        changeset
      end

      defoverridable validate: 2

      def validate_content(_content, changeset) do
        changeset
      end

      defoverridable validate_content: 2
    end
  end

  defmacro defattributes(attrs) do
    quote do
      @attributes unquote(attrs)
    end
  end

  defmacro defcontentmodule(attrs) do
    schema = Keyword.get(attrs, :schema)
    block_module = Keyword.get(attrs, :block_module)

    quote do
      defmodule Content do
        use Ecto.Schema
        @primary_key false

        import Ecto.Changeset

        alias ColonelKurtz.BlockTypes
        alias ColonelKurtz.ValidatableBlock

        @parent_module unquote(block_module)

        @derive [
          ValidatableBlock,
          {Jason.Encoder, only: unquote(Keyword.keys(schema))}
        ]
        embedded_schema do
          unquote do
            for {name, type} <- schema do
              quote do
                field(unquote(name), unquote(type))
              end
            end
          end
        end

        def from_map(attrs) do
          struct_attrs =
            for {name, type} <- unquote(schema),
                into: Keyword.new(),
                do: {name, Map.get(attrs, name)}

          struct!(__MODULE__, struct_attrs)
        end

        def changeset(content, params) do
          cset =
            struct!(__MODULE__)
            |> cast(params_map(params), Keyword.keys(unquote(schema)))

          ValidatableBlock.validate(content, cset)
        end

        def validate(content, changeset) do
          apply(@parent_module, :validate_content, [content, changeset])
        end

        defp params_map(params) when is_struct(params), do: Map.from_struct(params)
        defp params_map(params) when is_map(params), do: params
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def schema_keys() do
        Keyword.keys(@attributes || [])
      end

      def schema() do
        @attributes || []
      end
    end
  end

  defmacro __after_compile__(%{module: module}, _bytecode) do
    quote do
      defcontentmodule(schema: unquote(module.schema()), block_module: unquote(module))
    end
  end
end
