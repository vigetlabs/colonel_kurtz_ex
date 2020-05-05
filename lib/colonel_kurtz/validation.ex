defmodule ColonelKurtz.Validation do
  import Ecto.Changeset

  alias ColonelKurtz.EctoHelpers
  alias ColonelKurtz.ValidatableBlock

  def validate_blocks(%Ecto.Changeset{} = changeset, field) do
    validate_blocks(changeset, field, lift_errors: true)
  end

  def validate_blocks(%Ecto.Changeset{changes: changes} = changeset, field, opts) do
    lift_errors = Keyword.get(opts, :lift_errors)
    block_changesets = map_block_changesets(changes, field)

    changeset
    |> lift_blocks_validity(block_changesets)
    |> lift_block_errors(block_changesets, field, lift_errors)
    # for non-root blocks, insert the changes back into the changeset so that
    |> maybe_put_block_changes(block_changesets, field, !lift_errors)
  end

  def validate_blocks(%Ecto.Changeset{} = changeset, _field, _opts), do: changeset

  defp map_block_changesets(changes, field) do
    changes
    |> Map.get(field, [])
    |> to_changesets()
  end

  defp to_changesets(blocks) do
    Enum.map(blocks, fn block ->
      ValidatableBlock.changeset(block, Map.from_struct(block))
    end)
  end

  defp lift_blocks_validity(changeset, block_changesets) do
    case Enum.any?(block_changesets, fn cset -> !cset.valid? end) do
      false ->
        changeset

      true ->
        Map.put(changeset, :valid?, false)
    end
  end

  defp lift_block_errors(changeset, _block_changesets, _field, false), do: changeset

  defp lift_block_errors(changeset, block_changesets, field, true) do
    case Enum.any?(block_changesets, fn cset -> !cset.valid? end) do
      false ->
        changeset

      true ->
        changeset
        |> add_error(
          field,
          "one or more blocks are invalid, see the errors below",
          # we call this only when the changeset in question is a non Block and
          # we pass a list of block changesets (so we can look at the errors they contain)
          block_errors: map_blocks_errors(block_changesets)
        )
    end
  end

  defp maybe_put_block_changes(changeset, _block_changesets, _field, false), do: changeset

  defp maybe_put_block_changes(changeset, block_changesets, field, true) do
    put_change(changeset, field, block_changesets)
  end

  # is there another way to do this which is not recursive?
  defp map_blocks_errors(block_changesets) do
    Enum.map(block_changesets, fn %{changes: changes, errors: errors} ->
      %{
        block_id: Map.get(changes, :block_id),
        errors: prepare_block_errors(errors),
        blocks: map_blocks_errors(Map.get(changes, :blocks))
      }
    end)
  end

  defp prepare_block_errors(errors) do
    Enum.map(errors, fn {key, {message, opts}} ->
      %{
        key: Atom.to_string(key),
        message: EctoHelpers.format_error(message, opts)
      }
    end)
  end
end
