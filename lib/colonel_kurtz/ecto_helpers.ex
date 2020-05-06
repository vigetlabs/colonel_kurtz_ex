defmodule ColonelKurtz.EctoHelpers do
  @moduledoc """
  Ecto helpers such as `format_error` for formatting errors.
  """
  @spec format_error(binary, keyword) :: binary
  def format_error(message, opts) do
    Enum.reduce(opts, message, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
