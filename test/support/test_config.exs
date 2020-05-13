defmodule ColonelKurtzTest.TestConfig do
  @config Application.get_env(:colonel_kurtz_ex, ColonelKurtz)

  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      import ColonelKurtzTest.TestConfig, only: :functions

      setup do
        set_config(unquote(@config))
        on_exit(fn -> set_config(unquote(@config)) end)
      end
    end
  end

  def get_config() do
    Application.get_env(:colonel_kurtz_ex, ColonelKurtz)
  end


  def set_config(config) do
    Application.put_env(:colonel_kurtz_ex, ColonelKurtz, config)
  end

  def set_config_value(config, field, value) do
    Application.put_env(
      :colonel_kurtz_ex,
      ColonelKurtz,
      Keyword.merge(config, Keyword.new({field, value}))
    )
  end

  def clear_config() do
    Application.delete_env(:colonel_kurtz_ex, ColonelKurtz)
  end
end
