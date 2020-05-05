defmodule ColonelKurtz.EctoColonelKurtz do
  use Ecto.Type

  alias ColonelKurtz.BlockTypes

  def type, do: {:array, :map}

  def cast(data) when is_binary(data) do
    {:ok, BlockTypes.from_string(data)}
  end

  def cast(data) when is_list(data) do
    {:ok, Enum.map(data, &BlockTypes.from_map/1)}
  end

  def cast(_), do: :error

  def load(data) when is_list(data) do
    {:ok, Enum.map(data, &BlockTypes.from_map/1)}
  end

  def dump(blocks) when is_list(blocks) do
    {:ok, Enum.map(blocks, &Map.from_struct(&1))}
  end

  def dump(_), do: :error
end
