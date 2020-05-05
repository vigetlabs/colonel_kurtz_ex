defmodule ColonelKurtz.FormHelpers do
  import Phoenix.HTML, only: [raw: 1]
  import Phoenix.HTML.Form

  def block_editor(form, field), do: block_editor(form, field, [])

  def block_editor(%Phoenix.HTML.Form{} = f, field, opts) do
    [
      raw("<div data-ck-container=\"#{Atom.to_string(field)}\"></div>"),
      text_input(f, field,
        value: blocks_json(f, field, opts),
        hidden: true,
        data: ["ck-input": field]
      )
    ]
  end

  def blocks_json(form, field), do: blocks_json(form, field, [])

  def blocks_json(%Phoenix.HTML.Form{} = f, field, opts) do
    f
    |> input_value(field)
    |> blocks_json(block_errors(f, field), opts)
  end

  def blocks_json(blocks, errors, opts) when is_binary(blocks) do
    blocks
    |> Jason.decode!()
    |> to_json(opts)
  end

  def blocks_json(blocks, errors, opts) when is_list(blocks) and is_list(errors) do
    blocks
    |> blocks_with_errors(errors)
    |> to_json(opts)
  end

  def blocks_json(blocks, _errors, opts) when is_list(blocks) do
    blocks
    |> to_json(opts)
  end


  def block_errors_json(%Phoenix.HTML.Form{} = f, field), do: block_errors_json(f, field, [])

  def block_errors_json(%Phoenix.HTML.Form{} = f, field, opts) do
    case block_errors(f, field) do
      nil ->
        nil

      errors ->
        errors |> to_json(opts)
    end
  end

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

  defp merge_block_and_errors(block, block_errors) do
    Map.merge(block, %{
      # hack until we can pass arbitrary metadata to CK, just pass content once fixed
      content: Map.merge(Map.from_struct(block.content), %{errors: block_errors.errors}),
      errors: block_errors.errors,
      blocks: blocks_with_errors(block.blocks, block_errors.blocks)
    })
  end

  defp block_errors(%Phoenix.HTML.Form{source: %Ecto.Changeset{errors: []}}, _field), do: nil

  defp block_errors(%Phoenix.HTML.Form{source: %Ecto.Changeset{errors: errors}}, field) do
    case Keyword.get(errors, field) do
      blocks when is_tuple(blocks) ->
        blocks
        |> elem(1)
        |> Keyword.get(:block_errors)

      _ ->
        nil
    end
  end

  defp to_json(data), do: to_json(data, [])

  defp to_json(data, opts) do
    Jason.encode!(data, opts)
  end
end
