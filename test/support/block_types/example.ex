defmodule ColonelKurtzTest.BlockTypes.ExampleType do
  @moduledoc false
  use ColonelKurtz.BlockType, type: "example"

  import Ecto.Changeset

  defattributes(text: :string)

  def validate_content(_content, changeset) do
    changeset
    |> validate_required(:text)
  end
end
