defmodule ColonelKurtz.BlockTypeView do
  defmacro __using__(_opts) do
    quote do
      def renderable?(_block), do: true
      defoverridable renderable?: 1
    end
  end
end
