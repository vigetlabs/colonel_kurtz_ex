defmodule ColonelKurtz.EctoBlocks do
  @moduledoc """
  Implements a custom [Ecto.Type](https://hexdocs.pm/ecto/Ecto.Type.html#content)
  that models a serializable list of blocks stored as JSON.
  """

  use Ecto.Type

  alias ColonelKurtz.Block
  alias ColonelKurtz.BlockType
  alias ColonelKurtz.BlockTypes

  @typep block :: Block.t
  @typep block_struct :: BlockType.t

  def type, do: {:array, :map}

  @spec cast(binary | list(block)) :: {:ok, list(block_struct)} | :error
  def cast(data) when is_binary(data) do
    {:ok, BlockTypes.from_string(data)}
  end

  def cast(data) when is_list(data) do
    {:ok, Enum.map(data, &BlockTypes.from_map/1)}
  end

  def cast(_), do: :error

  @spec load(list(block)) :: {:ok, list(block_struct)}
  def load(data) when is_list(data) do
    {:ok, Enum.map(data, &BlockTypes.from_map/1)}
  end

  @spec dump(list(block_struct)) :: {:ok, list(block)} | :error
  def dump(blocks) when is_list(blocks) do
    {:ok, Enum.map(blocks, &Map.from_struct(&1))}
  end

  def dump(_), do: :error
end
