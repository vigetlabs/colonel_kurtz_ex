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
  defmacro __using__(args \\ []) do
    if content_schema_defined(args) do
      Code.eval_file("lib/colonel_kurtz/block_type/with_content.ex")
    else
      Code.eval_file("lib/colonel_kurtz/block_type/without_content.ex")
    end
  end

  defp content_schema_defined(args) do
    Keyword.get(args, :content, true)
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
