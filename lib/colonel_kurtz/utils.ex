defmodule ColonelKurtz.Utils do
  @moduledoc false
  def module_exists?(module) do
    function_exported?(module, :__info__, 1)
  end
end
