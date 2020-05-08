defmodule ColonelKurtzTest.BlockTypes.ExampleType do
  @moduledoc false
  use ColonelKurtz.BlockType

  import Ecto.Changeset

  embedded_schema do
    field(:text, :string)
  end

  def validate(_content, changeset) do
    changeset
    |> validate_required(:text)
  end
end
