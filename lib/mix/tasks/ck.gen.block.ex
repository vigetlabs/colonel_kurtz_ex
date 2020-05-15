defmodule Mix.Tasks.Ck.Gen.Block do
  @shortdoc "Generates a new CK block type"

  @moduledoc """
  A mix task that generates a new block type.
  """

  use Mix.Task
  alias Mix.ColonelKurtz.Context
  alias Mix.ColonelKurtz.Schema

  @switches [
    block: :boolean,
    content: :boolean,
    view: :boolean,
    template: :boolean,
    app: :string
  ]

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise "mix ck.gen.block can only be run inside an application directory"
    end

    {context, schema} = build(args)

    generate_block_module(context)
    generate_content_module(context)
    generate_view_module(context)
    generate_template(context)
  end

  defp generate_block_module(context) do
  end

  defp generate_content_module(context) do
  end

  defp generate_view_module(context) do
  end

  defp generate_templates(context) do
  end

  def build(args) do
    {opts, parsed, invalid} = Mix.ColonelKurtz.parse_opts(args, @switches)

    [schema_name | fields] = parsed

    schema_name
    |> Schema.new(fields)
    |> Context.new(opts)
  end

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

    blocks_path = block_types_context
                  |> Module.split()
                  |> Enum.drop(1)
                  |> Enum.map(&Phoenix.Naming.underscore/1)
                  |> Path.join()

    block_views_path = block_views_context
                       |> Module.split()
                       |> Enum.drop(1)
                       |> Enum.map(&Phoenix.Naming.underscore/1)
                       |> Path.join()

    blocks_target = Path.join(Mix.Phoenix.context_lib_path(Mix.Phoenix.otp_app(), blocks_path), Phoenix.Naming.underscore(schema_name) <> "_block.ex")

    block_views_target = Path.join(Mix.Phoenix.web_path(Mix.Phoenix.otp_app(), "views/" <> block_views_path), Phoenix.Naming.underscore(schema_name) <> "_view.ex")


    compiled = EEx.eval_file(source, binding)

    IO.inspect({blocks_target, block_views_target})
    # Mix.Generator.create_file(blocks_target, compiled)
  end
end
