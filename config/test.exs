use Mix.Config

config :phoenix, :json_library, Jason

config :colonel_kurtz_ex, ColonelKurtz,
  block_types: ColonelKurtzTest.BlockTypes,
  block_views: ColonelKurtzTest.Blocks
