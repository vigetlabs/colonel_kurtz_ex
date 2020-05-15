defmodule Mix.ColonelKurtz.Schema do
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

  # @valid_types [
  #   :integer,
  #   :float,
  #   :decimal,
  #   :boolean,
  #   :map,
  #   :string,
  #   :array,
  #   :references,
  #   :text,
  #   :date,
  #   :time,
  #   :time_usec,
  #   :naive_datetime,
  #   :naive_datetime_usec,
  #   :utc_datetime,
  #   :utc_datetime_usec,
  #   :uuid,
  #   :binary
  # ]

end
