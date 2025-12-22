defmodule UspAvalia.Avaliacoes.Avaliacao do
  use Ecto.Schema
  import Ecto.Changeset
  alias UspAvalia.Avaliacoes.{Professor, Disciplina}

  @required_fields [
    :nota_avaliacao,
    :nota_aula,
    :cobra_presenca?,
    :professor_id,
    :disciplina_codigo,
    :comentario_avaliacao,
    :comentario_aula,
    :comentario_cobra_presenca,
    :comentario_geral
  ]
  @optional_fields []

  @all_fields @optional_fields ++ @required_fields

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "avaliacoes" do
    field :comentario_geral, :string

    field :nota_avaliacao, :integer
    field :comentario_avaliacao, :string

    field :nota_aula, :integer
    field :comentario_aula, :string

    field :cobra_presenca?, :boolean
    field :comentario_cobra_presenca, :string

    belongs_to :professor, Professor, type: :binary_id

    belongs_to :disciplina, Disciplina,
      type: :string,
      foreign_key: :disciplina_codigo,
      references: :codigo

    belongs_to :author, UspAvalia.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(attrs, scope) do
    %__MODULE__{}
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> validate_is_email_usp(scope)
    |> validate_comentarios
    |> validate_notas
    |> relate(scope)
  end

  defp relate(changeset, scope) do
    changeset
    |> put_assoc(:author, scope.user)
  end

  defp validate_notas(changeset) do
    changeset
    |> validate_number(:nota_avaliacao, greater_than_or_equal_to: 0, less_than_or_equal_to: 10)
    |> validate_number(:nota_aula, greater_than_or_equal_to: 0, less_than_or_equal_to: 10)
  end

  defp validate_comentarios(changeset) do
    changeset
    |> validate_length(:comentario_avaliacao, min: 10, max: 500)
    |> validate_length(:comentario_aula, min: 10, max: 500)
    |> validate_length(:comentario_cobra_presenca, min: 10, max: 500)
  end

  defp validate_is_email_usp(changeset, %{user: %{email: email} = _scope}) do
    if String.ends_with?(email, "@usp.br") do
      changeset
    else
      add_error(changeset, :author, "must have a USP email")
    end
  end
end
