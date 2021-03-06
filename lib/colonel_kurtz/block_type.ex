defmodule ColonelKurtz.BlockType do
  @moduledoc """
  The BlockType module defines a macro that is used to mix in the Block Type
  behavior. Block Types are embedded Ecto Schemas.

  A Block has a `type` (e.g. "image"), a list of children (`blocks`), and a
  well-defined schema with content attributes (`content`). The content schema is
  defined by a user in a `TypeName.Content` module. The Block Type schema
  `embeds_one` of the Content module.
  """

  import Ecto.Changeset

  alias ColonelKurtz.EctoHelpers

  @type t :: %{
          :__struct__ => atom,
          required(:block_id) => nil | binary,
          required(:type) => binary,
          required(:content) => map,
          required(:blocks) => list(t)
        }

  @typep changeset :: Ecto.Changeset.t()

  @doc """
  The BlockType __using__ macro allows modules to behave as BlockTypes.
  """
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      import ColonelKurtz.Validation, only: [validate_blocks: 3]
      import Ecto.Changeset
      import ColonelKurtz.BlockType

      alias ColonelKurtz.Block
      alias ColonelKurtz.BlockType
      alias ColonelKurtz.CKBlocks
      alias ColonelKurtz.EctoHelpers

      @typep changeset :: Ecto.Changeset.t()
      @typep block :: block
      @typep block_struct :: BlockType.t()

      @block_attributes [:block_id, :type, :content, :blocks]

      @content_module Module.concat(__MODULE__, Content)

      @primary_key {:block_id, :binary_id, autogenerate: false}

      @derive {Jason.Encoder, only: @block_attributes}

      embedded_schema do
        field(:type, :string, null: false)
        field(:blocks, CKBlocks)
        embeds_one(:content, @content_module)
      end

      @doc """
      Given a named BlockType struct and a map of params, creates a changeset
      and runs validations for the BlockType and BlockType.Content.

      Returns %Ecto.Changeset{}.
      """
      @spec changeset(block_struct, map) :: changeset
      def changeset(block, params) do
        changeset =
          struct(__MODULE__)
          |> cast(params, [:block_id, :type, :blocks])
          |> cast_embed(:content)
          |> lift_content_errors()
          |> validate_blocks(:blocks, is_block: true)

        validate(block, changeset)
      end

      @spec validate(block_struct, changeset) :: changeset
      def validate(_block, changeset), do: changeset
      defoverridable validate: 2

      @doc """
      Takes a Block map and converts it to a named BlockType struct according
      to its :type. Generates a :block_id if necessary, and turns `block.content`
      into a named BlockType.Content module as well.
      """
      @spec from_map(block) :: block_struct
      def from_map(%{type: type, content: content, blocks: blocks} = attrs) do
        content =
          content
          |> attributes_from_params()
          |> @content_module.from_map()

        struct!(__MODULE__,
          block_id: Map.get(attrs, :block_id) || Ecto.UUID.generate(),
          type: type,
          content: content,
          blocks: blocks || []
        )
      end
    end
  end

  #
  # Lifts errors in the nested changeset for BlockType.Content to the changeset for
  # the BlockType itself.
  #
  # Explanation: Eventually, in order to surface errors for blocks in the UI, we
  # need to traverse the blocks and extract errors from their changesets. This will
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

  #
  # Extracts the Block's Content attributes from params, converting atom keys
  # to strings.
  #
  @spec attributes_from_params(map) :: map
  def attributes_from_params(params) do
    Enum.reduce(Map.keys(params), %{}, fn key, acc ->
      Map.put(acc, convert_key(key), Map.get(params, key))
    end)
  end

  defp convert_key(key) when is_binary(key), do: key
  defp convert_key(key) when is_atom(key), do: Atom.to_string(key)
end
