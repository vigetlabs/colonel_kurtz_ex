defmodule ColonelKurtzTest.BlockBuilders do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      alias ColonelKurtz.BlockType
      alias ColonelKurtz.BlockTypes

      import ColonelKurtzTest.BlockBuilders, only: :functions
    end
  end

  def build_block_type(module, attrs \\ []) do
    attrs
    |> block_type_attrs_with_defaults()
    |> module.from_map()
  end

  defp block_type_attrs_with_defaults(attrs) do
    Keyword.merge([content: %{}, blocks: []], attrs) |> Enum.into(%{})
  end
end
