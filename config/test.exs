use Mix.Config

config :phoenix, :json_library, Jason

config :colonel_kurtz, ColonelKurtz,
  block_types: ColonelKurtzTest.BlockTypes,
  block_views: ColonelKurtzTest.Blocks
