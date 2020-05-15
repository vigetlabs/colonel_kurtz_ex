defmodule ColonelKurtzTest.BlockTypes.SectionBlock do
  @moduledoc false
  use ColonelKurtz.BlockType, content: false

  def validate(_block, changeset) do
    changeset
    |> validate_length(:blocks, min: 1)
  end
end
