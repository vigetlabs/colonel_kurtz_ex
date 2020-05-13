defmodule ColonelKurtzTest.BlockTypesTest do
  @moduledoc false
  use ExUnit.Case, async: true
  use ColonelKurtzTest.BlockBuilders
  use ColonelKurtzTest.TestConfig

  alias ColonelKurtzTest.Blocks
  alias ColonelKurtzTest.BlockTypes.ExampleBlock

  doctest ColonelKurtz.BlockTypes

  describe "BlockTypes" do
    test "from_map/1 throws a RuntimeError if a block type module does not exist" do
      assert_raise RuntimeError, ~r/does not exist/, fn ->
        BlockTypes.from_map(%{
          type: "wrong"
        })
      end
    end

    test "from_map/1 throws a RuntimeError if ck configuration is missing block_types" do
      clear_config()
      set_config(block_views: Blocks)

      assert_raise RuntimeError, ~r/did not provide the :block_types field/, fn ->
        BlockTypes.from_map(%{
          type: "example"
        })
      end
    end

    test "from_map/1 throws a RuntimeError if ck configuration is missing" do
      clear_config()

      assert_raise RuntimeError, ~r/no configuration was found/, fn ->
        BlockTypes.from_map(%{
          type: "example"
        })
      end
    end

    test "from_map/1 returns a named block type struct" do
      assert %ExampleBlock{} = build_block_type(ExampleBlock, type: "example")
    end
  end
end
