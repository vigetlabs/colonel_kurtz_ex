defmodule ColonelKurtzTest.Blocks.ExampleView do
  use Phoenix.HTML

  use Phoenix.View,
    root: "test/support/templates",
    namespace: ColonelKurtzTest

  use ColonelKurtz.BlockView
end
