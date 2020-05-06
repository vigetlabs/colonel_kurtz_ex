defmodule ColonelKurtz.FormHelpers do
  @moduledoc """
  Form helpers for phoenix.
  """

  import Phoenix.HTML, only: [raw: 1]
  import Phoenix.HTML.Form

  alias Phoenix.HTML.Form

  @type form :: Phoenix.HTML.Form.t
  @type json_opts :: keyword | Jason.Encode.opts
  @type block_error :: %{errors: list(map), blocks: list(block_error)}
  @type block_with_errors :: %{content: map, errors: list(map), blocks: list(block_with_errors)}

  @spec block_editor(form, atom) :: list(Phoenix.HTML.safe)
  @spec block_editor(form, atom, json_opts) :: list(Phoenix.HTML.safe)
  def block_editor(form, field), do: block_editor(form, field, [])

  def block_editor(%Form{} = f, field, opts) do
    [
      raw("<div data-ck-container=\"#{Atom.to_string(field)}\"></div>"),
      text_input(f, field,
        value: blocks_json(f, field, opts),
        hidden: true,
        data: ["ck-input": field]
      )
    ]
  end

  @spec blocks_json(form, atom) :: binary
  @spec blocks_json(form, atom, json_opts) :: binary
  def blocks_json(form, field), do: blocks_json(form, field, [])

  def blocks_json(%Form{} = f, field, opts) do
    f
    |> input_value(field)
    |> blocks_json_from_blocks(block_errors(f, field), opts)
  end

  @spec blocks_json_from_blocks(list | binary, nil | list, json_opts) :: binary
  def blocks_json_from_blocks(blocks, _errors, _opts) when is_binary(blocks), do: blocks

  def blocks_json_from_blocks(blocks, errors, opts) when is_list(blocks) and is_list(errors) do
    blocks
    |> blocks_with_errors(errors)
    |> to_json(opts)
  end

  def blocks_json_from_blocks(blocks, _errors, opts) when is_list(blocks) do
    blocks
    |> to_json(opts)
  end

  @spec block_errors_json(form, atom) :: binary
  @spec block_errors_json(form, atom, json_opts) :: binary
  def block_errors_json(%Form{} = f, field), do: block_errors_json(f, field, [])

  def block_errors_json(%Form{} = f, field, opts) do
    case block_errors(f, field) do
      nil ->
        ""

      errors ->
        errors |> to_json(opts)
    end
  end

  @spec blocks_with_errors(list, nil | list) :: list
  defp blocks_with_errors(blocks, errors) when is_list(errors) do
    blocks
    |> Enum.zip(errors)
    |> Enum.map(fn {block, block_errors} ->
      block
      |> Map.from_struct()
      |> merge_block_and_errors(block_errors)
    end)
  end

  defp blocks_with_errors(blocks, nil), do: blocks

  @spec merge_block_and_errors(map, block_error) :: block_with_errors
  defp merge_block_and_errors(block, block_errors) do
    Map.merge(block, %{
      # NOTE(shawk): hack until we can pass errors or arbitrary metadata to CK,
      # just pass `block.content` once this capability is fixed in CK.
      content: Map.merge(Map.from_struct(block.content), %{errors: block_errors.errors}),
      errors: block_errors.errors,
      blocks: blocks_with_errors(block.blocks, block_errors.blocks)
    })
  end

  @spec block_errors(form, atom) :: nil | list(%{key: binary, message: binary})
  defp block_errors(%Form{source: %Ecto.Changeset{errors: []}}, _field),
    do: nil

  defp block_errors(%Form{source: %Ecto.Changeset{errors: errors}}, field) do
    case Keyword.get(errors, field) do
      blocks when is_tuple(blocks) ->
        blocks
        |> elem(1)
        |> Keyword.get(:block_errors)

      _ ->
        nil
    end
  end

  @spec to_json(maybe_improper_list, json_opts) :: binary
  defp to_json(data, opts) do
    Jason.encode!(data, opts)
  end
end
