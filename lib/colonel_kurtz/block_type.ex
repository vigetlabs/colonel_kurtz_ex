defmodule ColonelKurtz.BlockType do
  defmacro __using__(_opts) do
    quote do
      @type t :: %{
        :__struct__ => atom,
        required(:block_id) => nil | binary,
        required(:type) => binary,
        required(:content) => map,
        required(:blocks) => list(t)
      }
      @typep changeset :: Ecto.Changeset.t()

      use Ecto.Schema
      alias ColonelKurtz.EctoBlocks
      alias ColonelKurtz.EctoHelpers
      import ColonelKurtz.Validation, only: [validate_blocks: 3]
      import Ecto.Changeset
      import ColonelKurtz.BlockType

      @derive [Jason.Encoder]

      @primary_key {:block_id, :binary_id, autogenerate: false}

      # Lookup content module
      @content_module Module.concat(__MODULE__, Content)

      embedded_schema do
        field(:type, :string, null: false)
        field(:blocks, EctoBlocks)
        embeds_one(:content, @content_module)
      end

      @doc """
      Given a named BlockType struct and a map of params, creates a changeset
      and runs validations for the BlockType and BlockType.Content.

      Returns %Ecto.Changeset{}.
      """
      @spec changeset(t, map) :: changeset
      def changeset(block, params) do
        changeset =
          struct(__MODULE__)
          |> cast(params, [:block_id, :type, :blocks])
          |> cast_embed(:content)
          |> lift_content_errors()
          |> validate_blocks(:blocks, is_block: true)

        validate(block, changeset)
      end

      @spec validate(t, changeset) :: changeset
      def validate(_block, changeset), do: changeset
      defoverridable validate: 2

      @doc """
      Takes a Block map and converts it to a named BlockType struct according
      to its :type. Generates a :block_id if necessary, and turns `block.content`
      into a named BlockType.Content module as well.
      """
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

      #
      # Lifts errors in the nested changeset for BlockType.Content to the changeset for
      # the BlockType itself.
      #
      # Explanation: Eventually, in order to surface errors for blocks in the UI, we
      # need to traverse the blocks and extract errors from their changesets. This will
      # not include the errors for the embedded schema for this block's Content.
      # So we lift the errors from the nested changeset into the block's changeset.
      #
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
      # Extracts the Block's Content attributes from params, converting string keys
      # to atoms. Will only contain the keys specified in the schema (Defined by
      # using the `defattributes/1` macro).
      #
      def attributes_from_params(params) do
        Enum.reduce(Map.keys(params), %{}, fn key, acc ->
          Map.put(acc, key, Map.get(params, Atom.to_string(key), Map.get(params, key)))
        end)
      end
    end
  end
end

