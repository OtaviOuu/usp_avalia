defmodule UspAvalia.Avaliacoes.Repo.Avaliacao do
  alias UspAvalia.Repo
  alias UspAvalia.Avaliacoes.Entities.Avaliacao

  def list_by_code_and_professor(disciplina_id, professor_id) do
    Repo.all_by(Avaliacao, disciplina_id: disciplina_id, professor_id: professor_id)
  end
end
