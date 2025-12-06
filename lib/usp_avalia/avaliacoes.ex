defmodule UspAvalia.Avaliacoes do
  alias UspAvalia.Avaliacoes.Repo
  alias UspAvalia.Avaliacoes

  defdelegate list_disciplinas, to: Repo.Disciplina, as: :get_all

  defdelegate list_professores, to: Repo.Professor, as: :get_all

  defdelegate list_professores_by_disciplina_codigo(codigo),
    to: Repo.Professor,
    as: :get_all_by_disciplina_codigo

  defdelegate create_avaliacao(scope, attrs), to: Avaliacoes.UseCases.CreateAvaliacao, as: :call

  defdelegate get_professor_by_id(id), to: Repo.Professor, as: :get_by_id
  defdelegate get_disciplina_by_code(code), to: Repo.Disciplina, as: :get_by_code

  defdelegate change_avaliacao(attrs, scope),
    to: Avaliacoes.Entities.Avaliacao,
    as: :changeset
end
