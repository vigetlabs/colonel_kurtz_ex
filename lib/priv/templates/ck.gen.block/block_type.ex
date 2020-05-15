defmodule Foo do
  use ColonelKurtz.BlockType

  # customize your validations or delete this function
  def validate(_content, changeset) do
    changeset
  end
end
