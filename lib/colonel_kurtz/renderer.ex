defmodule ColonelKurtz.Renderer do
  @moduledoc """
  Provides a utility for rendering blocks. Requires the application to configure
  :block_views for ColonelKurtz.
  """

  alias ColonelKurtz.Block
  alias ColonelKurtz.Config
  alias ColonelKurtz.Utils

  @typep block :: Block.t()

  @spec render_blocks(nil) :: nil
  def render_blocks(nil), do: nil

  @spec render_blocks(list(block)) :: iodata
  def render_blocks(blocks) do
    Enum.map(blocks, &render_block/1)
  end

  @spec render_block(block) :: iodata
  defp render_block(%{type: type} = block) do
    type
    |> block_view_module!()
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

  @spec block_view_module!(binary) :: module | none
  def block_view_module!(type) do
    case lookup_block_view_module!(type) do
      {:error, :does_not_exist, module} ->
        raise RuntimeError,
          message: "The application configured :block_types, but #{module} does not exist."

      {:ok, module} ->
        module
    end
  end

  @spec lookup_block_view_module!(binary) :: {:ok, module} | {:error, :does_not_exist, module}
  defp lookup_block_view_module!(type) do
    case block_views_module() do
      {:ok, module} ->
        module
        |> block_view_module_name(type)
        |> Utils.module_exists?()

      {:error, :missing_field, field} ->
        raise RuntimeError,
          message:
            "Application defined :colonel_kurtz_ex config, but did not provide the :#{field} field."

      {:error, :missing_config} ->
        raise RuntimeError,
          message:
            "ColonelKurtz expected the application to configure :colonel_kurtz_ex, but no configuration was found."
    end
  end

  @spec block_views_module ::
          {:ok, module} | {:error, :missing_config} | {:error, :missing_field, :block_views}
  defp block_views_module do
    with {:ok, config} <- Config.fetch_config(),
         {:ok, module} <- Config.get(config, :block_views) do
      {:ok, module}
    end
  end

  @spec block_view_module_name(module, binary) :: module
  defp block_view_module_name(module, type) do
    Module.concat(module, Macro.camelize(type) <> "View")
  end
end
