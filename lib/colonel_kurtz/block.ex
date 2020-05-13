defmodule ColonelKurtz.Block do
  @moduledoc false

  @type t :: %{
          required(:type) => binary,
          required(:content) => map,
          required(:blocks) => list(t)
        }
end
