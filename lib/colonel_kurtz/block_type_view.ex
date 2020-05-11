defmodule ColonelKurtz.BlockTypeView do
  @moduledoc """
  The BlockTypeView defines a macro that modules (Phoenix.Views) can use to
  support a default implementation of `renderable?/1`.

  The `ColonelKurtz.Renderer` calls `renderable?/1` on user-defined BlockView
  modules as part of the rendering process (`render_blocks/1`).
  """

  @doc """
  The BlockType __using__ macro allows modules to behave as BlockTypeViews.
  """
  defmacro __using__(_opts) do
    quote do
      @spec renderable?(map) :: binary
      def renderable?(_block), do: true
      defoverridable renderable?: 1
    end
  end
end
