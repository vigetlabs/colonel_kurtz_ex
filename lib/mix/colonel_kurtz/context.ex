defmodule Mix.ColonelKurtz.Context do
  # see https://github.com/phoenixframework/phoenix/blob/master/lib/mix/phoenix/schema.ex
  alias Mix.ColonelKurtz.Schema

  defstruct attrs: [], types: []

  def new(%Schema{, opts}) do
  end
end
