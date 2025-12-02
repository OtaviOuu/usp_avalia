defmodule UspAvalia.Avaliacoes.Entities.ProfessoreDisciplina do
  use Ecto.Schema

  alias UspAvalia.Avaliacoes.Entities.{Professor, Disciplina}

  @primary_key false
  schema "professores_disciplinas" do
    belongs_to :professor, Professor, type: :binary_id
    belongs_to :disciplina, Disciplina, type: :binary_id

    timestamps(type: :utc_datetime)
  end
end
