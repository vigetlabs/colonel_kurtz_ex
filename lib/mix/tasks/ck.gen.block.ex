defmodule Mix.ColonelKurtz.Tasks.CK.Gen.Block do
  @shortdoc "Generates a new CK block type"

  @moduledoc """
  A mix task that generates a new block type.
  """

  use Mix.Task

  @switches [block: :boolean, view: :boolean, app: :string]

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise "mix ck.gen.block can only be run inside an application directory"
    end

    opts = parse_opts(args, @switches)
  end
end
