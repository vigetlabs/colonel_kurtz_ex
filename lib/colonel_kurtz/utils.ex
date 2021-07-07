defmodule ColonelKurtz.Utils do
  @moduledoc false
  @spec module_defined?(module) :: boolean
  def module_defined?(module) do
    function_exported?(module, :__info__, 1)
  end

  @spec module_exists?(module) :: {:ok, module} | {:error, :does_not_exist, module}
  def module_exists?(module) do
    case module_defined?(module) do
      false ->
        {:error, :does_not_exist, module}

      true ->
        {:ok, module}
    end
  end

  def module_or_fallback({:ok, module}, _fallback), do: module
  def module_or_fallback(_, fallback), do: fallback
end
