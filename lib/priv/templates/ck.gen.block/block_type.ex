defmodule <%= inspect context.module %> do
  use ColonelKurtz.BlockType

  embedded_schema do
  end

  def validate(_content, changeset) do
    changeset
  end
end
