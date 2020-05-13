defmodule ColonelKurtzTest.BlockTypes.ExampleBlock.Content do
  @moduledoc false
  use ColonelKurtz.BlockTypeContent

  embedded_schema do
    field(:text, :string, null: false)
  end

  def validate(_content, changeset) do
    changeset
    |> validate_required(:text)
  end
end
