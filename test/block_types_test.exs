defmodule ColonelKurtzTest.BlockTypesTest do
  @moduledoc false

  # @NOTE(shawk): cannot be async due to https://hexdocs.pm/ex_unit/ExUnit.CaptureLog.html#capture_log/2
  use ExUnit.Case
  use ColonelKurtzTest.BlockBuilders
  use ColonelKurtzTest.TestConfig

  import ExUnit.CaptureLog

  alias ColonelKurtz.UnrecognizedBlock
  alias ColonelKurtzTest.Blocks
  alias ColonelKurtzTest.BlockTypes.ExampleBlock

  require Logger

  doctest ColonelKurtz.BlockTypes

  describe "BlockTypes" do
    test "from_map/1 warns if a block type module does not exist" do
      assert capture_log(fn ->
               BlockTypes.from_map(%{type: "wrong"})
             end) =~ "does not exist"
    end

    test "from_map/1 warns if ck configuration is missing block_types" do
      clear_config()
      set_config(block_views: Blocks)

      assert capture_log(fn ->
               BlockTypes.from_map(%{
                 type: "example"
               })
             end) =~ "did not provide the :block_types field"
    end

    test "render_blocks/1 warns if ck configuration is missing block_views" do
      clear_config()
      set_config(block_types: ColonelKurtzTest.BlockTypes)

      assert capture_log(fn ->
               ColonelKurtz.render_blocks([
                 BlockTypes.from_map(%{
                   type: "example"
                 })
               ])
             end) =~ "did not provide the :block_views field"
    end

    test "from_map/1 warns if ck configuration is missing" do
      clear_config()

      assert capture_log(fn ->
               BlockTypes.from_map(%{
                 type: "example"
               })
             end) =~ "no configuration was found"
    end

    test "from_map/1 returns an UnrecognizedBlock with the block content preserved if it cannot locate the block module" do
      clear_config()

      # @TODO(shawk): better fixtures
      assert capture_log(fn ->
               assert %UnrecognizedBlock{
                        type: "missing",
                        content: %{
                          "foo" => "bar"
                        },
                        blocks: [
                          %UnrecognizedBlock{
                            type: "absent",
                            content: %{
                              "baz" => "qux"
                            }
                          }
                        ]
                      } =
                        BlockTypes.from_map(%{
                          type: "missing",
                          content: %{
                            foo: "bar"
                          },
                          blocks: [
                            BlockTypes.from_map(%{
                              type: "absent",
                              content: %{
                                baz: "qux"
                              }
                            })
                          ]
                        })
             end) =~ "no configuration was found"
    end

    test "from_map/1 returns a named block type struct" do
      assert %ExampleBlock{} = build_block_type(ExampleBlock, type: "example")
    end
  end
end
