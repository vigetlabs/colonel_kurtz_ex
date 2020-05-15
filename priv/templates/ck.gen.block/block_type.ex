<%= if context.opts[:block] do %>defmodule <%= inspect context.block_module %> do
  use ColonelKurtz.BlockType

  # customize your validations or delete this function
  # TODO: link to a guide about block validations
  def validate(_block, changeset) do
    changeset
  end
end

<% end %><%= if context.opts[:content] do %>defmodule <%= inspect context.content_module %> do
  use ColonelKurtz.BlockTypeContent

  embedded_schema do
    <%= for {k, v} <- context.types do %>field(<%= inspect k %>, <%= inspect v %>)
    <% end %>
  end

  # customize your validations or delete this function
  # TODO: link to a guide about content validations
  def validate(_content, changeset) do
    changeset
  end
end<% end %>
