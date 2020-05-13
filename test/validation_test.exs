defmodule ColonelKurtzTest.ValidationTest do
  use ExUnit.Case, async: false

  alias ColonelKurtzTest.Post

  doctest ColonelKurtz.Validation

  describe "Validation" do
    test "validate_blocks/1 runs validations on all blocks" do
      post =
        Post.changeset(%Post{}, %{
          content: [
            %{
              type: "example",
              content: %{},
              blocks: []
            }
          ]
        })

      assert %{
               valid?: false,
               errors: [
                 content:
                   {_,
                    [
                      block_errors: [
                        %{errors: [%{key: "text", message: "can't be blank"}]}
                      ]
                    ]}
               ]
             } = post
    end
  end
end
