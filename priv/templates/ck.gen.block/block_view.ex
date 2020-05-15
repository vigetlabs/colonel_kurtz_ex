defmodule <%= inspect context.view_module %> do
  use <%= inspect context.web_context %>, :view
  use ColonelKurtz.BlockTypeView
end
