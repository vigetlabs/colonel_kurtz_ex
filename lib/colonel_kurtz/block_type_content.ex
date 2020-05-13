defmodule ColonelKurtz.BlockTypeContent do
  @moduledoc """
  `BlockTypeContent` is used to model the inner `content` field for a given block
  type. Each block type has a unique schema represented by an Ecto.Schema that
  defines an `embedded_schema` for the expected fields (corresponding with the
  JS implementation for this block type).

  Modules that use this macro may optionally define a `validate/2` that receives
  the Content struct and a changeset with the fields in their `embedded_schema`
  already cast and ready to be validated.
  """

  alias ColonelKurtz.BlockType
  alias ColonelKurtz.Utils

  @type t :: %{
          :__struct__ => atom,
          optional(any) => any
        }

  @doc """
  Macro for mixing in the BlockTypeContent behavior.
  """
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import ColonelKurtz.BlockTypeContent

      alias ColonelKurtz.BlockTypeContent
      alias ColonelKurtz.BlockTypes

      @typep changeset :: Ecto.Changeset.t()
      @typep block_content :: BlockTypeContent.t()

      @before_compile ColonelKurtz.BlockTypeContent

      @primary_key false

      @derive [Jason.Encoder]

      @spec changeset(block_content, map) :: changeset
      def changeset(content, params) do
        embeds = __schema__(:embeds)
        fields = __schema__(:fields) -- embeds

        changeset =
          struct!(__MODULE__)
          |> cast(params_map(params), fields)

        changeset_with_embeds =
          Enum.reduce(embeds, changeset, fn embed_name, c ->
            cast_embed(c, embed_name)
          end)

        validate(content, changeset_with_embeds)
      end

      @spec from_map(keyword) :: block_content
      def from_map(attrs) do
        struct_attrs =
          for name <- __schema__(:fields),
              into: Keyword.new(),
              do: {name, Map.get(attrs, name)}

        struct!(__MODULE__, struct_attrs)
      end

      @spec validate(block_content, changeset) :: changeset
      def validate(_content, changeset), do: changeset
      defoverridable validate: 2
    end
  end

  def __before_compile__(%{module: module}) do
    block_module_contents =
      quote do
        use BlockType
      end

    module
    |> get_block_module_name()
    |> maybe_create(block_module_contents)
  end

  @spec get_block_module_name(module) :: module
  defp get_block_module_name(content_module_name) do
    content_module_name
    |> Module.split()
    |> Enum.drop(-1)
    |> Module.concat()
  end

  @spec maybe_create(atom, Macro.t()) :: nil | {:module, module, binary, term}
  defp maybe_create(module, module_contents) do
    unless Utils.module_defined?(module) do
      Module.create(module, module_contents, Macro.Env.location(__ENV__))
    end
  end

  @spec params_map(map | struct) :: map
  def params_map(params) when is_struct(params),
    do: Map.from_struct(params)

  def params_map(params) when is_map(params),
    do: params
end
