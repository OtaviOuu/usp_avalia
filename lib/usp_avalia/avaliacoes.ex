defmodule UspAvalia.Avaliacoes do
  alias UspAvalia.Avaliacoes.Repo

  defdelegate list_disciplinas, to: Repo.Disciplina, as: :get_all
  defdelegate list_professores, to: Repo.Professor, as: :get_all
  defdelegate get_professor_by_id(id), to: Repo.Professor, as: :get_by_id
end
