defmodule ColonelKurtz.BlockTypeContent do
  @moduledoc false

  @type t :: %{
          :__struct__ => atom,
          optional(any) => any
        }

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      @primary_key false

      import Ecto.Changeset
      import ColonelKurtz.BlockTypeContent

      alias ColonelKurtz.BlockTypes

      @derive [Jason.Encoder]

      @before_compile ColonelKurtz.BlockTypeContent

      def changeset(content, params) do
        embeds = __schema__(:embeds)
        fields = __schema__(:fields) -- embeds

        cset =
          struct!(__MODULE__)
          |> cast(params_map(params), fields)

        cset =
          Enum.reduce(embeds, cset, fn embed_name, cset ->
            cast_embed(cset, embed_name)
          end)

        validate(content, cset)
      end

      def from_map(attrs) do
        struct_attrs =
          for name <- __schema__(:fields),
              into: Keyword.new(),
              do: {name, Map.get(attrs, name)}

        struct!(__MODULE__, struct_attrs)
      end

      def validate(_content, changeset), do: changeset
      defoverridable validate: 2
    end
  end

  def __before_compile__(%{module: module}) do
    block_module_contents =
      quote do
        use ColonelKurtz.BlockType
      end

    module
    |> get_block_module_name()
    |> maybe_create(block_module_contents)
  end

  defp get_block_module_name(content_module_name) do
    content_module_name
    |> Module.split()
    |> Enum.drop(-1)
    |> Module.concat()
  end

  defp maybe_create(module, module_contents) do
    case ColonelKurtz.Utils.module_exists?(module) do
      false ->
        Module.create(module, module_contents, Macro.Env.location(__ENV__))

      true ->
        module
    end
  end

  @spec params_map(map | struct) :: map
  def params_map(params) when is_struct(params),
    do: Map.from_struct(params)

  def params_map(params) when is_map(params),
    do: params
end
