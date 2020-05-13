defmodule ColonelKurtz.Config do
  @moduledoc false
  @type t :: [
          block_types: module,
          block_views: module
        ]

  alias ColonelKurtz.Config

  @spec fetch_config :: {:ok, Config.t()} | {:error, :missing_config}
  def fetch_config do
    case Application.fetch_env(:colonel_kurtz_ex, ColonelKurtz) do
      :error -> {:error, :missing_config}
      config -> config
    end
  end

  @spec get(Config.t(), atom) :: {:ok, module} | {:error, :missing_field, atom}
  def get(config, field) do
    case Keyword.fetch(config, field) do
      :error -> {:error, :missing_field, field}
      block_types -> block_types
    end
  end
end
