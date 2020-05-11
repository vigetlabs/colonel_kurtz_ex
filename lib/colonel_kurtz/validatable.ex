defprotocol ColonelKurtz.Validatable do
  @moduledoc false

  @type changeset :: Ecto.Changeset.t

  @spec changeset(struct, map) :: changeset
  def changeset(struct, params)

  @spec validate(struct, changeset) :: changeset
  def validate(struct, cset)
end

defimpl ColonelKurtz.Validatable, for: Any do
  defmacro __deriving__(module, _struct, _options) do
    quote do
      defimpl ColonelKurtz.Validatable, for: unquote(module) do
        def changeset(struct, params) do
          apply(unquote(module), :changeset, [struct, params])
        end

        def validate(struct, cset) do
          apply(unquote(module), :validate, [struct, cset])
        end
      end
    end
  end

  def changeset(_struct, _params) do
    %Ecto.Changeset{}
  end

  def validate(_struct, changeset) do
    changeset
  end
end
