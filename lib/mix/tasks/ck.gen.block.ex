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
    template: :boolean
    # app: :string
  ]

  @default_switches [
    block: true,
    content: true,
    view: true,
    template: true
  ]

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise("mix ck.gen.block can only be run inside an application directory")
    end

    context = build(args)

    generate_block_module(context)
    generate_view_module(context)
    generate_template(context)
  end

  defp generate_block_module(context) do
    if context.opts[:block] || context.opts[:content] do
      compiled = EEx.eval_file(context.block_template, context.bindings)
      target = Path.join([context.block_path, context.block_file])

      Mix.Generator.create_file(target, compiled)

      Mix.shell().info("""
      View the generated block at #{target}. You should add validations and any further customizations to the schema field options.
      """)
    end
  end

  defp generate_view_module(context) do
    if context.opts[:view] do
      compiled = EEx.eval_file(context.view_template, context.bindings)
      target = Path.join([context.view_path, context.view_file])

      Mix.Generator.create_file(target, compiled)
    end
  end

  defp generate_template(context) do
    if context.opts[:template] do
      Mix.Generator.copy_file(
        context.template_template,
        Path.join(context.template_path, context.template_file)
      )
    end
  end

  def build(args) do
    {opts, parsed, _invalid} = Mix.ColonelKurtz.parse_opts(args, @switches)

    opts = Keyword.merge(@default_switches, opts)

    [schema_name | fields] = parsed

    schema_name
    |> Schema.new(fields)
    |> Context.new(opts)
  end
end
