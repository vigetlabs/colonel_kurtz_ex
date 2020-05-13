defmodule ColonelKurtzTest.Post do
  @moduledoc false
  use Ecto.Schema

  import ColonelKurtz, only: [validate_blocks: 2]
  import Ecto.Changeset

  alias ColonelKurtz.CKBlocks

  embedded_schema do
    field(:content, CKBlocks, default: [])
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:content])
    |> validate_blocks(:content)
  end
end
