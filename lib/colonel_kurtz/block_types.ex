defmodule ColonelKurtz.BlockTypes do
  @moduledoc """
  Provides functions for marshalling data into named BlockType structs.
  """

  alias ColonelKurtz.Block
  alias ColonelKurtz.BlockType
  alias ColonelKurtz.Utils

  @typep block :: Block.t()
  @typep block_struct :: BlockType.t()

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
  def from_map(%{"type" => type} = data) do
    %{
      type: type,
      block_id: Map.get(data, "block_id"),
      content: Map.get(data, "content", %{}),
      blocks: Map.get(data, "blocks", []) |> Enum.map(&from_map/1)
    }
    |> to_block_type_struct
  end

  @doc """
  Convert a map with atom keys to a named block type struct.
  """
  def from_map(%{type: type} = data) do
    %{
      type: type,
      block_id: Map.get(data, :block_id),
      content: Map.get(data, :content, %{}),
      blocks: Map.get(data, :blocks, []) |> Enum.map(&from_map/1)
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
  def block_type_module(type) do
    block_types_module()
    |> Module.concat(Macro.camelize(type) <> "Block")
  end

  @spec block_types_module :: module
  defp block_types_module do
    with {:ok, config} <- Utils.fetch_config(),
         {:ok, module} <- Utils.block_types_config(config) do
      module
    else
      {:error, :missing_config} ->
        raise RuntimeError,
          message:
            "ColonelKurtz expected the application to configure :colonel_kurtz_ex, but no configuration was found."

      {:error, :missing_block_types} ->
        raise RuntimeError,
          message:
            "Application defined :colonel_kurtz_ex config, but did not provide the :block_types field."
    end
  end

  defp block_type_module_name(module, type) do
    Module.concat(module, Macro.camelize(type) <> "Block")
  end

  defp module_exists?(module) do
    case Utils.module_exists?(module) do
      false ->
        {:error, :does_not_exist, module}

      true ->
        module
    end
  end
end
