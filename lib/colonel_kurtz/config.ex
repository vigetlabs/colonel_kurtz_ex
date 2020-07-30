defmodule ColonelKurtz.Config do
  @moduledoc false
  @type t :: [
          block_types: module,
          block_views: module
        ]

  alias ColonelKurtz.Config

  @spec fetch_config() :: {:ok, Config.t()} | {:error, :missing_config}
  def fetch_config do
    case Application.fetch_env(:colonel_kurtz, ColonelKurtz) do
      :error -> {:error, :missing_config}
      config -> config
    end
  end

  @spec get(Config.t(), atom) :: {:ok, module} | {:error, :missing_field, atom()}
  def get(config, field) do
    case Keyword.fetch(config, field) do
      :error -> {:error, :missing_field, field}
      block_types -> block_types
    end
  end

  @dialyzer {:nowarn_function, get!: 1}
  def get!(field) do
    with {:ok, config} <- fetch_config(),
         {:ok, value} <- get(config, field) do
      value
    else
      {:error, :missing_field, field} ->
        raise "Configuration is missing field #{field}"

      {:error, :missing_config} ->
        raise "Missing configuration :colonel_kurtz"
    end
  end
end
