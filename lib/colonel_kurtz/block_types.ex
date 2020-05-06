defmodule ColonelKurtz.BlockTypes do
  @moduledoc """
  Provides methods for marshalling data into named BlockType structs.
  """

  alias ColonelKurtz.Block
  alias ColonelKurtz.BlockType

  @typep block :: Block.t
  @typep block_struct :: BlockType.t

  @doc """
  Converts serialized json into named block type structs.
  """
  @spec from_string(binary) :: list(block_struct)
  def from_string(data) when is_binary(data) do
    data
    |> Jason.decode!()
    |> Enum.map(&from_map/1)
  end

  @doc """
  Convert a map with string keys to a named block type struct.
  """
  @spec from_map(block) :: block_struct
  def from_map(%{"type" => type, "content" => content, "blocks" => blocks} = data) do
    %{
      block_id: Map.get(data, "block_id"),
      type: type,
      content: content,
      blocks: Enum.map(blocks, &from_map/1)
    }
    |> to_block_type_struct
  end

  @doc """
  Convert a map with atom keys to a named block type struct.
  """
  def from_map(%{type: type, content: content, blocks: blocks} = data) do
    %{
      block_id: Map.get(data, :block_id),
      type: type,
      content: content,
      blocks: Enum.map(blocks, &from_map/1)
    }
    |> to_block_type_struct
  end

  # private

  @spec to_block_type_struct(map) :: block_struct
  defp to_block_type_struct(%{type: type} = block) do
    type
    |> block_type_module()
    |> apply(:from_map, [block])
  end

  @spec block_type_module(binary) :: module
  defp block_type_module(type) do
    Module.concat(block_types_module(), Macro.camelize(type) <> "Block")
  end

  @spec block_types_module :: module
  defp block_types_module do
    case Application.fetch_env!(:colonel_kurtz_ex, ColonelKurtz) do
      config when is_list(config) ->
        Keyword.get(config, :block_types)

      _ ->
        raise RuntimeError,
          message:
            "ColonelKurtz expected the application to configure :block_types, but it was empty."
    end
  end
end
