defmodule UspAvalia.Avaliacoes.Repo.ProfessorDisciplina do
  import Ecto.Query, warn: false
  alias UspAvalia.Repo

  def get_by_professor_and_disciplina(professor_id, disciplina_codigo) do
    query =
      from pd in UspAvalia.Avaliacoes.ProfessoreDisciplina,
        where: pd.professor_id == ^professor_id and pd.disciplina_codigo == ^disciplina_codigo

    Repo.one(query)
    |> Repo.preload([:professor, :disciplina])
  end
end
