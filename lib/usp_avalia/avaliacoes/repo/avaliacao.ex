defmodule UspAvalia.Avaliacoes.Repo.Avaliacao do
  alias UspAvalia.Repo
  alias UspAvalia.Avaliacoes.Entities.Avaliacao

  def get_by_id(id, opts) do
    Avaliacao
    |> Repo.get_by(id: id)
    |> handle_preload(opts)
  end

  def list_by_code_and_professor(disciplina_id, professor_id) do
    Repo.all_by(Avaliacao, disciplina_id: disciplina_id, professor_id: professor_id)
  end

  defp handle_preload(query_result, opts) do
    preload = Keyword.get(opts, :load, [])

    Repo.preload(query_result, preload)
  end
end
