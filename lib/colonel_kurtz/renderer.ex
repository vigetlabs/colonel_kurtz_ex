defmodule ColonelKurtz.Renderer do
  @moduledoc """
  Provides a utility for rendering blocks. Requires the application to configure
  :block_views for ColonelKurtz.
  """

  alias ColonelKurtz.Block
  alias ColonelKurtz.Config
  alias ColonelKurtz.UnrecognizedBlockView
  alias ColonelKurtz.Utils

  require Logger

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
    |> block_view_module()
    |> maybe_render_block(block)
  end

  @spec maybe_render_block(module, block) :: iodata
  defp maybe_render_block(UnrecognizedBlockView, _block), do: ""

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

  @spec block_view_module(binary) :: module | none
  def block_view_module(type) do
    case lookup_block_view_module(type) do
      {:error, :does_not_exist, module} ->
        Logger.warn("The application configured :block_types, but #{module} does not exist.")
        UnrecognizedBlockView

      {:error, :missing_field, field} ->
        Logger.warn(
          "Application defined :colonel_kurtz_ex config, but did not provide the :#{field} field."
        )

        UnrecognizedBlockView

      {:error, :missing_config} ->
        Logger.warn(
          "ColonelKurtz expected the application to configure :colonel_kurtz_ex, but no configuration was found."
        )

        UnrecognizedBlockView

      {:ok, module} ->
        module
    end
  end

  @spec lookup_block_view_module(binary) ::
          {:ok, module}
          | {:error, :does_not_exist, module}
          | {:error, :missing_config}
          | {:error, :missing_field, :block_views}
  defp lookup_block_view_module(type) do
    with {:ok, block_types} <- block_views_module(),
         {:ok, module} <- Utils.module_exists?(block_view_module_name(block_types, type)) do
      {:ok, module}
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
    Module.concat(module, Recase.to_pascal(type) <> "View")
  end
end
