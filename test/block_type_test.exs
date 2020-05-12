defmodule ColonelKurtzTest.BlockTypeTest do
  @moduledoc false
  use ExUnit.Case
  use ColonelKurtzTest.BlockBuilders

  doctest ColonelKurtz.BlockType

  alias ColonelKurtz.Validatable
  alias ColonelKurtzTest.BlockTypes.ExampleBlock

  describe "BlockType" do
    test "example" do
      block = build_block_type(ExampleBlock, content: %{text: "Example"})

      assert %ExampleBlock{} = block
      assert %{valid?: true} = Validatable.changeset(block, Map.from_struct(block))
    end

    test "returns false for invalid block" do
      block = build_block_type(ExampleBlock, content: %{text: ""})

      assert %{valid?: false} = Validatable.changeset(block, Map.from_struct(block))
    end
  end

  describe "Renderer" do
    test "render_blocks/1 renders blocks" do
      blocks = [
        build_block_type(ExampleBlock, content: %{text: "Example"})
      ]

      assert [safe: ["<div>\n  <p>", "Example", "</p>\n</div>\n"]] = ColonelKurtz.Renderer.render_blocks(blocks)
    end
  end
end
