defmodule UspAvalia.Avaliacoes.Entities.Avaliacao do
  use Ecto.Schema
  import Ecto.Changeset
  alias UspAvalia.Avaliacoes.Entities.{Professor, Disciplina}

  @fields [:nota, :comentario, :professor_id, :disciplina_id]

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "avaliacoes" do
    field :nota, :integer
    field :comentario, :string

    belongs_to :professor, Professor, type: :binary_id
    belongs_to :disciplina, Disciplina, type: :binary_id

    belongs_to :author, UspAvalia.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(attrs, scope) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate(scope)
    |> relate(scope)
  end

  defp validate(changeset, scope) do
    changeset
    |> validate_required(@fields)
    |> validate_is_email_usp(scope)
    |> validate_inclusion(:nota, 0..10)
    |> validate_length(:comentario,
      min: 2,
      max: 255
    )
  end

  defp relate(changeset, scope) do
    changeset
    |> put_assoc(:author, scope.user)
  end

  defp validate_is_email_usp(changeset, %{user: %{email: email} = _scope}) do
    if String.ends_with?(email, "@usp.br") do
      changeset
    else
      add_error(changeset, :author, "must have a USP email")
    end
  end
end
