defmodule Mix.ColonelKurtz.Context do
  # see https://github.com/phoenixframework/phoenix/blob/master/lib/mix/phoenix/schema.ex
  alias Mix.ColonelKurtz.Schema
  alias Mix.ColonelKurtz.Context

  defstruct opts: nil,
            bindings: nil,
            block_template: nil,
            view_template: nil,
            template_template: nil,
            block_file: nil,
            view_file: nil,
            template_file: nil,
            block_path: nil,
            view_path: nil,
            template_path: nil

  def new(%Schema{} = schema, opts) do
    ck_app_dir = Application.app_dir(:colonel_kurtz)

    block_template = Path.join(ck_app_dir, "priv/templates/ck.gen.block/block_type.ex")
    view_template = Path.join(ck_app_dir, "priv/templates/ck.gen.block/block_view.ex")
    template_template = Path.join(ck_app_dir, "priv/templates/ck.gen.block/index.html.eex")

    block_types_context = ColonelKurtz.Config.get!(:block_types)
    block_views_context = ColonelKurtz.Config.get!(:block_views)

    block_module = Module.concat(
      [
        block_types_context,
        Recase.to_pascal(schema.name) <> "Block"
      ]
    )

    bindings = [
      context: %{
        block_module: block_module,
        content_module: Module.concat(block_module, Content),
        view_module: Module.concat(block_views_context, Recase.to_pascal(schema.name) <> "View"),
        web_context: Mix.Phoenix.web_module(Mix.Phoenix.base()),
        opts: opts,
        types: schema.types
      }
    ]

    web_prefix = Mix.Phoenix.web_path(Mix.Phoenix.context_app())
    template_folder = block_views_context |> Module.split() |> Enum.drop(1) |> List.first() |> Phoenix.Naming.underscore()
    template_target = Path.join([web_prefix, "templates", template_folder, schema.name])

    %Context{
      opts: opts,
      bindings: bindings,

      block_template: block_template,
      view_template: view_template,
      template_template: template_template,

      block_file: Phoenix.Naming.underscore(schema.name) <> "_block.ex",
      view_file: Phoenix.Naming.underscore(schema.name) <> "_view.ex",
      template_file: "index.html.eex",

      block_path: blocks_target(module_path(block_types_context)),
      view_path: views_target(module_path(block_views_context)),
      template_path: template_target
    }
  end

  defp module_path(module) do
    module
    |> Module.split()
    |> Enum.drop(1)
    |> Enum.map(&Phoenix.Naming.underscore/1)
    |> Path.join()
  end

  defp blocks_target(path) do
    Mix.Phoenix.context_lib_path(Mix.Phoenix.otp_app(), path)
  end

  defp views_target(path) do
    Mix.Phoenix.web_path(Mix.Phoenix.otp_app(), "views/" <> path)
  end
end
