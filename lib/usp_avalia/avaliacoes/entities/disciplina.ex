defmodule UspAvalia.Avaliacoes.Entities.Disciplina do
  use Ecto.Schema
  import Ecto.Changeset

  alias UspAvalia.Avaliacoes.Entities.Professor

  @fields [:codigo, :nome, :instituto]
  @required_fields []

  @primary_key false
  schema "disciplinas" do
    field :codigo, :string, primary_key: true
    field :nome, :string
    field :instituto, :string

    many_to_many :professores, Professor,
      join_through: "professores_disciplinas",
      join_keys: [disciplina_codigo: :codigo, professor_id: :id]

    timestamps(type: :utc_datetime)
  end

  def changeset(disciplina, attrs) do
    disciplina
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
