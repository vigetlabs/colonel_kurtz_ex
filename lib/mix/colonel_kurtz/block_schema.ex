defmodule Mix.ColonelKurtz.BlockTypeContentSchema do
  # see https://github.com/phoenixframework/phoenix/blob/master/lib/mix/phoenix/schema.ex

  defstruct attrs: [], types: []

  @valid_types [
    :integer,
    :float,
    :decimal,
    :boolean,
    :map,
    :string,
    :array,
    :references,
    :text,
    :date,
    :time,
    :time_usec,
    :naive_datetime,
    :naive_datetime_usec,
    :utc_datetime,
    :utc_datetime_usec,
    :uuid,
    :binary
  ]

  def new(schema_name, fields) do
    types = Mix.Phoenix.Schema.attrs(fields)

    source = Path.join(Application.app_dir(:colonel_kurtz), "priv/templates/ck.gen.block/block_type.ex")
    block_types_context = ColonelKurtz.Config.get!(:block_types)
    block_views_context = ColonelKurtz.Config.get!(:block_views)

    block_module = Module.concat(
      [
        block_types_context,
        Recase.to_pascal(schema_name) <> "Block"
      ]
    )

    content_module = Module.concat(block_module, Content)

    binding = [
      context: %{
        block_module: block_module,
        content_module: content_module,
        types: types
      }
    ]

    target = Mix.Phoenix.context_app_path(block_types_context, ".")
    target2 = Mix.Phoenix.web_path(block_views_context, ".")

    compiled = EEx.eval_file(source, binding)
    IO.inspect({target, target2})
    # Mix.Generator.create_file(target, compiled)
  end
end
