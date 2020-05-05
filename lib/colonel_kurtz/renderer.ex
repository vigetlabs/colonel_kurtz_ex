defmodule ColonelKurtz.Renderer do
  def render_blocks(nil), do: nil

  def render_blocks(blocks) do
    Enum.map(blocks, &render_block/1)
  end

  defp render_block(%{type: type} = block) do
    type
    |> view_module()
    |> maybe_render_block(block)
  end

  @doc """
  Conditionally renders a block if it is renderable.
  """
  defp maybe_render_block(module, block) do
    if apply(module, :renderable?, [block]) do
      apply(module, :render, ["index.html", assigns(block)])
    else
      ""
    end
  end

  defp assigns(%{content: content, blocks: blocks} = _block) do
    [
      content: content,
      children: render_blocks(blocks)
    ]
  end

  defp view_module(type) do
    Module.concat(block_views_module(), Macro.camelize(type) <> "View")
  end

  defp block_views_module() do
    case Application.fetch_env!(:colonel_kurtz_ex, ColonelKurtz) do
      config when is_list(config) ->
        Keyword.get(config, :block_views)

      _ ->
        raise RuntimeError, message: "ColonelKurtz expected the application to configure :block_views, but it was empty."
    end
  end
end
