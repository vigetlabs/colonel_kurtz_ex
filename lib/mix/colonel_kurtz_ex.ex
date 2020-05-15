defmodule Mix.ColonelKurtz do
  # CLI API:
  #
  # mix ck.gen.block example text:string
  alias ColonelKurtz.Config

  def parse_opts(args, switches) do
    {opts, parsed, invalid} = OptionParser.parse(args, switches: switches)
  end
end
