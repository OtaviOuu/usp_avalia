defmodule UspAvalia.Avaliacoes.Entities.Disciplina do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:codigo, :nome, :instituto]
  @required_fields []

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "disciplinas" do
    field :codigo, :string
    field :nome, :string
    field :instituto, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(disciplina, attrs) do
    disciplina
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
