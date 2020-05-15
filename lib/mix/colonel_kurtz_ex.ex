defmodule Mix.ColonelKurtz do
  defp parse_opts(args, switches) do
    {opts, _parsed, _invalid} = OptionParser.parse(args, switches: switches)

    opt_app = opts[:app] || Config.get!(:otp_app)

    unless otp_app do
      Mix.raise("""
        You need to specify an OTP app to generate files within. Either
        configure it as shown below or pass it in via the `--app` option.

          config :colonel_kurtz, ColonelKurtz,
            otp_app: :my_app

        Alternatively

          mix ck.gen.block --app my_app
        """)
    end
  end
end
