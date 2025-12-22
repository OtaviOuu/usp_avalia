defmodule UspAvalia.Avaliacoes.ProfessoreDisciplina do
  use Ecto.Schema

  alias UspAvalia.Avaliacoes.{Professor, Disciplina}

  @primary_key false
  schema "professores_disciplinas" do
    belongs_to :professor, Professor, type: :binary_id

    belongs_to :disciplina, Disciplina,
      type: :string,
      foreign_key: :disciplina_codigo,
      references: :codigo
  end
end
