defmodule ColonelKurtz.BlockType do
  @moduledoc """
  The BlockType module defines a macro that is used to mix in the Block Type
  behavior. Block Types are embedded Ecto Schemas that conform to the
  Validatable protocol.

  A Block is of some type (e.g. "Image Block") and have a well-defined schema
  for the attributes they require. That schema is specified as a dynamically
  generated nested module within the using module and is defined by a user call
  to the `defattributes` macro that specifies the schema for the Blocks' Content.
  The Block Type schema embeds_one of the Content module.
  """

  import Ecto.Changeset, only: [add_error: 4]
  import ColonelKurtz.BlockTypeContent, only: [defcontentmodule: 1]

  alias ColonelKurtz.Block
  alias ColonelKurtz.EctoHelpers

  @type changeset :: Ecto.Changeset.t

  @type t :: %{
    :__struct__ => atom,
    required(:block_id) => nil | binary,
    required(:type) => binary,
    required(:content) => map,
    required(:blocks) => list(Block.t)
  }

  defmacro __using__(opts) do
    quote do
      use Ecto.Schema
      @primary_key {:block_id, :binary_id, autogenerate: false}

      import unquote(__MODULE__), only: [
        defattributes: 1,
        attributes_from_params: 2,
        lift_content_errors: 1
      ]

      import Ecto.Changeset
      import ColonelKurtz.Validation, only: [validate_blocks: 3]

      alias ColonelKurtz.BlockTypes
      alias ColonelKurtz.EctoBlocks
      alias ColonelKurtz.Validatable

      @before_compile unquote(__MODULE__)
      @after_compile unquote(__MODULE__)

      @block_type unquote(opts[:type])
      @block_attributes [:block_id, :type, :content, :blocks]
      @content_attributes []
      @content_module Module.concat(__MODULE__, Content)

      @derive [
        Validatable,
        {Jason.Encoder, only: @block_attributes}
      ]
      embedded_schema do
        field(:type, :string)
        field(:blocks, EctoBlocks)
        embeds_one(:content, @content_module)
      end

      def from_map(%{type: @block_type, content: content, blocks: blocks} = attrs) do
        struct!(__MODULE__,
          block_id: Map.get(attrs, :block_id) || Ecto.UUID.generate(),
          type: @block_type,
          content: @content_module.from_map(content_attributes(content)),
          blocks: blocks || []
        )
      end

      def changeset(block, params) do
        changeset =
          struct(__MODULE__)
          |> cast(params, [:block_id, :type, :blocks])
          |> cast_embed(:content)
          |> lift_content_errors()
          |> validate_blocks(:blocks, is_block: true)

        Validatable.validate(block, changeset)
      end

      @doc """
      An overridable method that gets called with the `block.content` params when
      creating a new Block of a given type. Must return data that conforms to the
      Content module's schema.

      This is useful if you want to do any additional formatting or if any of
      the fields in your schema are computed.
      """
      def content_attributes(params) do
        attributes_from_params(content_schema_keys(), params)
      end
      defoverridable content_attributes: 1

      def validate(_block, changeset), do: changeset
      defoverridable validate: 2

      def validate_content(_content, changeset), do: changeset
      defoverridable validate_content: 2
    end
  end

  defmacro defattributes(attrs) do
    quote do
      @content_attributes unquote(attrs)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def content_schema_keys do
        Keyword.keys(@content_attributes || [])
      end

      def content_schema do
        @content_attributes || []
      end
    end
  end

  defmacro __after_compile__(%{module: module}, _bytecode) do
    quote do
      defcontentmodule(
        schema: unquote(module.content_schema()),
        block_module: unquote(module)
      )
    end
  end

  @doc """
  Extracts the Block's Content attributes from params, converting string keys
  to atoms. Will only contain the keys specified in the schema (Defined by
  using the `defattributes/1` macro).
  """
  @spec attributes_from_params(list(atom), map) :: map
  def attributes_from_params(schema_keys, params) do
    Enum.reduce(schema_keys, %{}, fn key, acc ->
      Map.put(acc, key, Map.get(params, Atom.to_string(key), Map.get(params, key)))
    end)
  end

  #
  # Eventually, in order to surface errors for blocks in the UI, we need to
  # traverse the blocks and extract errors from their changesets. This will
  # not include the errors for the embedded schema for this block's Content.
  # So we lift the errors from the nested changeset into the block's changeset.
  #
  @spec lift_content_errors(changeset) :: changeset
  def lift_content_errors(%{changes: %{content: %{errors: errors}}} = changeset)
      when is_list(errors) do
    Enum.reduce(errors, changeset, fn {key, {message, opts}}, acc ->
      acc
      |> Map.put(:valid?, false)
      |> add_error(key, EctoHelpers.format_error(message, opts), opts)
    end)
  end

  def lift_content_errors(changeset), do: changeset
end
