defmodule ColonelKurtz.BlockTypes do
  @doc """
  Converts serialized json into named block type structs
  """
  def from_string(data) when is_binary(data) do
    data
    |> Jason.decode!()
    |> Enum.map(&from_map/1)
  end

  @doc """
  Convert a map with string keys to a named block type struct
  """
  def from_map(%{"type" => type, "content" => content, "blocks" => blocks} = data) do
    %{
      block_id: Map.get(data, "block_id"),
      type: type,
      content: content,
      blocks: Enum.map(blocks, &from_map/1)
    }
    |> to_block_type
  end

  def from_map(%{type: type, content: content, blocks: blocks} = data) do
    %{data | block_id: Map.get(data, :block_id)}
    |> to_block_type
  end

  # private

  defp to_block_type(%{type: type} = block) do
    type
    |> block_type_module()
    |> apply(:from_map, [block])
  end

  defp block_type_module(type) do
    Module.concat(block_types_module(), Macro.camelize(type) <> "Block")
  end

  # TODO(shawk): refer to app config by library name after mixifying
  defp block_types_module() do
    case Application.fetch_env!(:blog_demo, ColonelKurtz) do
      config when is_list(config) ->
        Keyword.get(config, :block_types)

      _ ->
        raise RuntimeError, message: "ColonelKurtz expected the application to configure :block_types, but it was empty."
    end
  end
end
