defmodule Mix.Tasks.Ck.Gen.Block do
  @shortdoc "Generates a new CK block type"

  @moduledoc """
  A mix task that generates a new block type.
  """

  use Mix.Task

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

    opts = Mix.ColonelKurtz.parse_opts(args, @switches)

    # if opts[:block] || opts[:content], generate block type module
    #   if opts[:block], generate block module
    #   if opts[:content], generate content module
    # if opts[:view], generate block view module
    # if opts[:template], generate template
  end
end
