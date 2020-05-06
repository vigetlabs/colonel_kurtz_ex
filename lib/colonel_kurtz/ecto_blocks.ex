defmodule ColonelKurtz.EctoBlocks do
  @moduledoc """
  Implements a custom Ecto.Type (https://hexdocs.pm/ecto/Ecto.Type.html#content)
  that models a serializable list of blocks stored as JSON.
  """
  use Ecto.Type

  alias ColonelKurtz.BlockTypes

  @type block :: %{
    required(:type) => binary,
    required(:content) => map,
    required(:blocks) => list(block)
  }

  @type block_struct :: %{
    :__struct__ => atom,
    required(:block_id) => nil | binary,
    required(:type) => binary,
    required(:content) => content_struct,
    required(:blocks) => list(block_struct)
  }

  @type content_struct :: %{
    :__struct__ => atom,
    optional(any) => any
  }

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
