defmodule ColonelKurtz.UnrecognizedBlock do
  @moduledoc """
  Used to represent a block whose type, when looked up, cannot be correlated to
  a loaded module (based on configuration).
  """
  use ColonelKurtz.UnrecognizedBlockType
end
