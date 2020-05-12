defmodule ColonelKurtz.Validation do
  @moduledoc """
  `ColonelKurtz.Validation` provides `validate_blocks/2` and `validate_blocks/3`
  which are used to validate block data.
  """

  import Ecto.Changeset

  alias ColonelKurtz.BlockTypes
  alias ColonelKurtz.EctoHelpers

  @type changeset :: %Ecto.Changeset{changes: map}
  @type changeset_list :: list(changeset)

  @doc """
  Given a changeset with an EctoBlocks field of the name specified as `field`,
  validates the blocks contained in `changeset.changes.<field>`.

  Returns %Ecto.Changeset{}.
  """
  @spec validate_blocks(changeset, atom | list(atom)) :: changeset
  def validate_blocks(%Ecto.Changeset{} = changeset, field_or_fields) do
    validate_blocks(changeset, field_or_fields, is_block: false)
  end

  def validate_blocks(%Ecto.Changeset{} = changeset, fields, opts) when is_list(fields) do
    Enum.reduce(fields, changeset, fn field, changeset ->
      validate_blocks(changeset, field, opts)
    end)
  end

  def validate_blocks(%Ecto.Changeset{changes: changes} = changeset, field, opts) do
    is_block = Keyword.get(opts, :is_block)
    block_changesets = map_block_changesets(changes, field)

    #
    # In order to validate the blocks and set the embedding schema to the correct
    # state:
    #
    # 1. First, mark the changeset as invalid if any of the blocks have validation errors
    #
    # 2. If the changeset is not a Block, and the blocks are invalid, add a
    #    helpful error to the changeset
    #
    # 3. If the changeset is a Block, insert the changes back into the changeset so
    #    that eventually when we `map_block_errors` we will have a tree of changesets
    #    to recursively walk in order to extract all errors
    #
    changeset
    |> lift_blocks_validity(block_changesets)
    |> maybe_add_blocks_error(block_changesets, field, !is_block)
    |> maybe_put_block_changes(block_changesets, field, is_block)
  end

  def validate_blocks(%Ecto.Changeset{} = changeset, _field, _opts), do: changeset

  @spec map_block_changesets(map, atom) :: changeset_list
  defp map_block_changesets(changes, field) do
    changes
    |> Map.get(field, [])
    |> to_changesets()
  end

  @spec to_changesets(list(map)) :: changeset_list
  defp to_changesets(blocks) do
    Enum.map(blocks, fn block ->
      BlockTypes.block_type_module(block.type).changeset(block, Map.from_struct(block))
    end)
  end

  @spec lift_blocks_validity(changeset, changeset_list) :: changeset
  defp lift_blocks_validity(changeset, block_changesets) do
    case Enum.any?(block_changesets, fn cset -> !cset.valid? end) do
      false ->
        changeset

      true ->
        Map.put(changeset, :valid?, false)
    end
  end

  @spec maybe_add_blocks_error(changeset, changeset_list, atom, boolean) :: changeset
  defp maybe_add_blocks_error(changeset, _block_changesets, _field, false = _is_block),
    do: changeset

  defp maybe_add_blocks_error(changeset, block_changesets, field, true = _is_block) do
    case Enum.any?(block_changesets, fn cset -> !cset.valid? end) do
      false ->
        changeset

      true ->
        changeset
        |> add_error(
          field,
          "one or more blocks are invalid, see the errors below",
          block_errors: map_blocks_errors(block_changesets)
        )
    end
  end

  @spec maybe_put_block_changes(changeset, changeset_list, atom, boolean) :: changeset
  defp maybe_put_block_changes(
         %Ecto.Changeset{} = changeset,
         _block_changesets,
         _field,
         false = _is_block
       ),
       do: changeset

  defp maybe_put_block_changes(changeset, block_changesets, field, true = _is_block) do
    put_change(changeset, field, block_changesets)
  end

  # Is there another way to do this which is not recursive? The main trouble
  # is we need a deeply nested tree of changesets in order to collect all the
  # errors which requires us to `put_change` via Ecto in order to ensure
  # `changeset.changes.blocks` is a changeset rather than data.
  @spec map_blocks_errors(changeset_list) :: list(map)
  defp map_blocks_errors(block_changesets) do
    Enum.map(block_changesets, fn %{changes: changes, errors: errors} ->
      %{
        block_id: Map.get(changes, :block_id),
        errors: prepare_block_errors(errors),
        blocks: map_blocks_errors(Map.get(changes, :blocks))
      }
    end)
  end

  @spec prepare_block_errors(list(tuple)) :: list(%{key: binary, message: binary})
  defp prepare_block_errors(errors) do
    Enum.map(errors, fn {key, {message, opts}} ->
      %{
        key: Atom.to_string(key),
        message: EctoHelpers.format_error(message, opts)
      }
    end)
  end
end
