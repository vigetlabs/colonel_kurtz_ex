defmodule ColonelKurtz.Renderer do
  @moduledoc """
  Provides a utility for rendering blocks. Requires the application to configure
  :block_views for ColonelKurtz.
  """

  alias ColonelKurtz.Block

  @typep block :: Block.t

  @spec render_blocks(nil) :: nil
  def render_blocks(nil), do: nil

  @spec render_blocks(list(block)) :: iodata
  def render_blocks(blocks) do
    Enum.map(blocks, &render_block/1)
  end

  @spec render_block(block) :: iodata
  defp render_block(%{type: type} = block) do
    type
    |> view_module()
    |> maybe_render_block(block)
  end

  @spec maybe_render_block(module, block) :: iodata
  defp maybe_render_block(module, block) do
    if apply(module, :renderable?, [block]) do
      apply(module, :render, ["index.html", assigns(block)])
    else
      ""
    end
  end

  @spec assigns(block) :: [content: map, children: list(iodata)]
  defp assigns(%{content: content, blocks: blocks} = _block) do
    [
      content: content,
      children: render_blocks(blocks)
    ]
  end

  @spec view_module(binary) :: module
  defp view_module(type) do
    Module.concat(block_views_module(), Macro.camelize(type) <> "View")
  end

  @spec block_views_module :: module
  defp block_views_module do
    case Application.get_env(:colonel_kurtz_ex, ColonelKurtz) do
      config when is_list(config) ->
        Keyword.get(config, :block_views)

      _ ->
        raise RuntimeError,
          message:
            "ColonelKurtz expected the application to configure :block_views, but it was empty."
    end
  end
end
