defmodule ColonelKurtz.BlockTypes do
  @moduledoc """
  Provides functions for marshalling data into named BlockType structs.
  """

  alias ColonelKurtz.Block
  alias ColonelKurtz.BlockType
  alias ColonelKurtz.Config
  alias ColonelKurtz.UnrecognizedBlock
  alias ColonelKurtz.Utils

  require Logger

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

  @spec block_type_module(binary) :: module
  def block_type_module(type) do
    type
    |> lookup_block_type_module()
    |> maybe_issue_warning()
    |> Utils.module_or_fallback(UnrecognizedBlock)
  end

  # private

  @spec to_block_type_struct(map) :: block_struct
  defp to_block_type_struct(%{type: type} = block) do
    type
    |> block_type_module()
    |> apply(:from_map, [block])
  end

  @spec lookup_block_type_module(binary) ::
          {:ok, module}
          | {:error, :does_not_exist, module}
          | {:error, :missing_config}
          | {:error, :missing_field, :block_types}
  defp lookup_block_type_module(type) do
    with {:ok, config} <- Config.fetch_config(),
         {:ok, block_types} <- Config.get(config, :block_types),
         {:ok, module_name} <- block_type_module_name(block_types, type),
         {:ok, module} <- Utils.module_exists?(module_name) do
      {:ok, module}
    end
  end

  @spec block_type_module_name(module, binary) :: {:ok, module}
  defp block_type_module_name(module, type) do
    {:ok, Module.concat(module, Recase.to_pascal(type) <> "Block")}
  end

  defp maybe_issue_warning({:ok, module}), do: {:ok, module}

  defp maybe_issue_warning(result) do
    case result do
      {:error, :does_not_exist, module} ->
        Logger.warn("The application configured :block_types, but #{module} does not exist.")

      {:error, :missing_field, field} ->
        Logger.warn(
          "Application defined :colonel_kurtz_ex config, but did not provide the :#{field} field."
        )

      {:error, :missing_config} ->
        Logger.warn(
          "ColonelKurtz expected the application to configure :colonel_kurtz_ex, but no configuration was found."
        )

      _ ->
        nil
    end

    # just return the result
    result
  end
end
