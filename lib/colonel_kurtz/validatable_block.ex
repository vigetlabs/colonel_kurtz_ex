defprotocol ColonelKurtz.ValidatableBlock do
  @spec changeset(map(), map()) :: %Ecto.Changeset{}
  def changeset(struct, params)

  @spec validate(map(), %Ecto.Changeset{}) :: %Ecto.Changeset{}
  def validate(struct, cset)
end

defimpl ColonelKurtz.ValidatableBlock, for: Any do
  defmacro __deriving__(module, _struct, _options) do
    quote do
      defimpl ColonelKurtz.ValidatableBlock, for: unquote(module) do
        import Ecto.Changeset

        def changeset(block, params) do
          apply(unquote(module), :changeset, [block, params])
        end

        def validate(block, cset) do
          apply(unquote(module), :validate, [block, cset])
        end
      end
    end
  end

  def changeset(_block, _params) do
    %Ecto.Changeset{}
  end

  def validate(_block, changeset) do
    changeset
  end
end
