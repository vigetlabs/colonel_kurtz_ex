defmodule ColonelKurtz.BlockTypeContent do
  @moduledoc false

  defmacro __using__(schema: schema, block_module: block_module) do
    quote do
      use Ecto.Schema
      @primary_key false

      import unquote(__MODULE__)
      import Ecto.Changeset

      alias ColonelKurtz.BlockTypes
      alias ColonelKurtz.Validatable

      @block_module unquote(block_module)

      @derive [
        Validatable,
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

        Validatable.validate(content, cset)
      end

      def validate(content, changeset) do
        apply(@block_module, :validate_content, [content, changeset])
      end
    end
  end

  defmacro defcontentmodule(attrs) do
    schema = Keyword.get(attrs, :schema)
    block_module = Keyword.get(attrs, :block_module)

    quote do
      defmodule Content do
        @moduledoc false
        use ColonelKurtz.BlockTypeContent, schema: unquote(schema), block_module: unquote(block_module)
      end
    end
  end

  @spec params_map(map | struct) :: map
  def params_map(params) when is_struct(params),
    do: Map.from_struct(params)

  def params_map(params) when is_map(params),
    do: params
end
