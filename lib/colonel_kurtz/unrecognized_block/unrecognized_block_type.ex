defmodule ColonelKurtz.UnrecognizedBlockType do
  @moduledoc false

  @type t :: %{
          :__struct__ => atom,
          required(:block_id) => nil | binary,
          required(:type) => binary,
          required(:content) => map,
          required(:blocks) => list(t)
        }

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import ColonelKurtz.Validation, only: [validate_blocks: 3]
      import ColonelKurtz.BlockType

      alias ColonelKurtz.Block
      alias ColonelKurtz.BlockType
      alias ColonelKurtz.CKBlocks
      alias ColonelKurtz.UnrecognizedBlock

      @typep changeset :: Ecto.Changeset.t()
      @typep block :: block
      @typep block_struct :: BlockType.t()

      @block_attributes [:block_id, :type, :content, :blocks]

      @primary_key {:block_id, :binary_id, autogenerate: false}

      @derive {Jason.Encoder, only: @block_attributes}

      embedded_schema do
        field(:type, :string, null: false)
        field(:blocks, CKBlocks)
        field(:content, :map)
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
          |> cast(params, [:block_id, :type, :blocks, :content])
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
        struct!(__MODULE__,
          block_id: Map.get(attrs, :block_id) || Ecto.UUID.generate(),
          type: type,
          content: BlockType.attributes_from_params(content),
          blocks: blocks || []
        )
      end
    end
  end
end
