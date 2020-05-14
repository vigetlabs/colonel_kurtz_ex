defmodule ColonelKurtzTest.BlockTypeTest do
  @moduledoc false
  use ExUnit.Case, async: true
  use ColonelKurtzTest.BlockBuilders
  use ColonelKurtzTest.TestConfig

  doctest ColonelKurtz.BlockType

  alias ColonelKurtzTest.BlockTypes.ExampleBlock

  describe "BlockType" do
    test "example" do
      block = build_block_type(ExampleBlock, type: "example", content: %{text: "Example"})

      assert %ExampleBlock{} = block
      assert %{valid?: true} = ExampleBlock.changeset(block, Map.from_struct(block))
    end

    test "returns false for invalid block" do
      block = build_block_type(ExampleBlock, type: "example", content: %{text: ""})

      assert %{valid?: false} = ExampleBlock.changeset(block, Map.from_struct(block))
    end
  end

  describe "Renderer" do
    test "render_blocks/1 renders nothing if given no blocks" do
      assert [] = ColonelKurtz.Renderer.render_blocks([])
    end

    test "render_blocks/1 renders blocks" do
      blocks = [
        build_block_type(ExampleBlock, type: "example", content: %{text: "Example"})
      ]

      assert [safe: ["<div>\n  <p>", "Example", "</p>\n</div>\n"]] =
               ColonelKurtz.Renderer.render_blocks(blocks)
    end
  end

  describe "#attributes_from_params/1" do
    # https://github.com/vigetlabs/colonel_kurtz_ex/issues/10
    test "returns a map with string keys when given a map with string keys" do
      params = %{"src" => "imagesrc.png"}
      assert %{"src" => "imagesrc.png"} = ColonelKurtz.BlockType.attributes_from_params(params)
    end

    test "returns a map with string keys when given a map with atom keys" do
      params = %{src: "imagesrc.png"}
      assert %{"src" => "imagesrc.png"} = ColonelKurtz.BlockType.attributes_from_params(params)
    end

    test "returns a map with string keys when given a map with mixed keys" do
      params = %{"src" => "imagesrc.png", other_prop: "other_value"}

      assert %{"src" => "imagesrc.png", "other_prop" => "other_value"} =
               ColonelKurtz.BlockType.attributes_from_params(params)
    end
  end
end
