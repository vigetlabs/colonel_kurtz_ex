defmodule Mix.ColonelKurtz.Schema do
  @moduledoc false

  # see https://github.com/phoenixframework/phoenix/blob/master/lib/mix/phoenix/schema.ex

  alias Mix.ColonelKurtz.Schema

  defstruct name: nil, types: []

  def new(schema_name, fields) do
    types = Mix.Phoenix.Schema.attrs(fields)

    %Schema{
      name: schema_name,
      types: types
    }
  end
end
