defmodule ColonelKurtz.Utils do
  @moduledoc false
  def fetch_config() do
    case Application.fetch_env(:colonel_kurtz_ex, ColonelKurtz) do
      :error -> {:error, :missing_config}
      config -> config
    end
  end

  def block_types_config(config) do
    case Keyword.fetch(config, :block_types) do
      :error -> {:error, :missing_block_types}
      block_types -> block_types
    end
  end

  def module_exists?(module) do
    function_exported?(module, :__info__, 1)
  end
end
