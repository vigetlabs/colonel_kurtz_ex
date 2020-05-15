defmodule <%= inspect context.block_module %> do
  use ColonelKurtz.BlockType

  # customize your validations or delete this function
  def validate(_block, changeset) do
    changeset
  end
end

defmodule <%= inspect context.content_module %> do
  use ColonelKurtz.BlockTypeContent

  embedded_schema do
    <%= for {k, v} <- context.types do %>    field <%= inspect k %>, <%= inspect v %>
      <% #context.defaults[k] %>
  <% end %>
  end

  # customize your validations or delete this function
  def validate(_content, changeset) do
    changeset
  end
end
