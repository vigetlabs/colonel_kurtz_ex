defmodule ColonelKurtzTest.BlockTypesTest do
  @moduledoc false
  use ExUnit.Case
  use ColonelKurtzTest.BlockBuilders

  doctest ColonelKurtz.BlockTypes

  alias ColonelKurtz.BlockTypes
  alias ColonelKurtzTest.BlockTypes.ExampleBlock

  describe "BlockTypes" do
    test "from_map/1 throws a RuntimeError if it cannot look up a block type module" do
      assert_raise RuntimeError, ~r/does not exist/, fn ->
        BlockTypes.from_map(%{
          type: "wrong",
          content: %{},
          blocks: []
        })
      end
    end

    test "from_map/1 returns a named block type struct" do
      assert %ExampleBlock{} = build_block_type(ExampleBlock, type: "example")
    end
  end
end
