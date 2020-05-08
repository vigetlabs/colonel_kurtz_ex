defmodule ColonelKurtzTest do
  @moduledoc false
  use ExUnit.Case
  doctest ColonelKurtz

  alias ColonelKurtzTest.BlockTypes.ExampleType

  def example_type_with_content(content) do
    ExampleType.Block.from_map(%{
      type: "example",
      blocks: [],
      content: content
    })
  end

  describe "BlockType" do
    test "example" do
      block = example_type_with_content(%{text: "Example"})

      assert %ExampleType.Block{} = block
      assert %{valid?: true} = ExampleType.Block.changeset(block, Map.from_struct(block))
    end

    test "returns false for invalid block" do
      block = example_type_with_content(%{text: ""})

      assert %{valid?: false} = ExampleType.Block.changeset(block, Map.from_struct(block))
    end
  end

  describe "Renderer" do
    test "render_blocks/1 renders blocks" do
      blocks = [
        example_type_with_content(%{text: "Example"})
      ]

      assert [safe: ["<div>\n  <p>", "Example", "</p>\n</div>\n"]] =
               ColonelKurtz.Renderer.render_blocks(blocks)
    end
  end
end
