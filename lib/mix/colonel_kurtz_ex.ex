defmodule Mix.ColonelKurtz do
  @moduledoc """
  Entrypoint for the CK mix tasks.

  CLI API:
  `mix ck.gen.block block_name text:string`
  """

  def parse_opts(args, switches) do
    {_opts, _parsed, _invalid} = OptionParser.parse(args, switches: switches)
  end
end
