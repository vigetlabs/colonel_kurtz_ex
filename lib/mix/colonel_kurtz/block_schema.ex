defmodule Mix.ColonelKurtz.BlockTypeContentSchema do
  # see https://github.com/phoenixframework/phoenix/blob/master/lib/mix/phoenix/schema.ex

  defstruct attrs: [], types: []

  @valid_types [
    :integer,
    :float,
    :decimal,
    :boolean,
    :map,
    :string,
    :array,
    :references,
    :text,
    :date,
    :time,
    :time_usec,
    :naive_datetime,
    :naive_datetime_usec,
    :utc_datetime,
    :utc_datetime_usec,
    :uuid,
    :binary
  ]
end
