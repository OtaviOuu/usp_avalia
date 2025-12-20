defmodule UspAvalia.Avaliacoes.Entities.Professor do
  use Ecto.Schema
  import Ecto.Changeset

  alias UspAvalia.Avaliacoes.Entities.Disciplina

  @fields [:nome, :email, :salario]
  @required_fields [:nome, :email]

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "professores" do
    field :nome, :string
    field :email, :string
    field :salario, :integer, default: nil

    field :numero_disciplinas, :integer, virtual: true

    many_to_many :disciplinas, Disciplina,
      join_through: "professores_disciplinas",
      join_keys: [professor_id: :id, disciplina_codigo: :codigo]

    timestamps(type: :utc_datetime)
  end

  def changeset(professor, attrs) do
    professor
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
