defmodule ColonelKurtzExTest do
  use ExUnit.Case
  doctest ColonelKurtzEx

  test "greets the world" do
    assert ColonelKurtzEx.hello() == :world
  end
end
