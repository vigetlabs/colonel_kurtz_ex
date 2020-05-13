defmodule ColonelKurtz do
  @moduledoc """
  Defines the most commonly used functions in ColonelKurtz.
  """
  defdelegate render_blocks(blocks), to: ColonelKurtz.Renderer
  defdelegate validate_blocks(changeset, field), to: ColonelKurtz.Validation
  defdelegate validate_blocks(changeset, field, opts), to: ColonelKurtz.Validation
  defdelegate block_editor(form, field), to: ColonelKurtz.FormHelpers
  defdelegate block_editor(form, field, opts), to: ColonelKurtz.FormHelpers
  defdelegate blocks_json(form, field), to: ColonelKurtz.FormHelpers
  defdelegate blocks_json(form, field, opts), to: ColonelKurtz.FormHelpers
end
