defmodule UspAvalia.Avaliacoes do
  @behaviour Bodyguard.Policy

  # auth podre. Melhor manter um modulo de auth para cada dominio e apneas embrulhar a chamada
  def authorize(:create_avaliacao, %{verified: true} = _user, _), do: :ok
  def authorize(:create_avaliacao, _, _), do: false

  alias UspAvalia.Avaliacoes.Repo
  alias UspAvalia.Avaliacoes

  defdelegate list_disciplinas, to: Repo.Disciplina, as: :get_all

  defdelegate list_professores, to: Repo.Professor, as: :get_all

  defdelegate list_professores_by_disciplina_codigo(codigo),
    to: Repo.Professor,
    as: :get_all_by_disciplina_codigo

  defdelegate list_avaliacoes_by_code_and_professor(disciplina_id, professor_id),
    to: Repo.Avaliacao,
    as: :list_by_code_and_professor

  def create_avaliacao(scope, attrs) do
    with :ok <- Bodyguard.permit(__MODULE__, :create_avaliacao, scope) do
      Avaliacoes.UseCases.CreateAvaliacao.call(scope, attrs)
    end
  end

  def can_create_avaliacao?(scope) do
    case Bodyguard.permit(__MODULE__, :create_avaliacao, scope) do
      :ok -> true
      _ -> false
    end
  end

  defdelegate get_professor_by_id(id), to: Repo.Professor, as: :get_by_id
  defdelegate get_disciplina_by_code(code), to: Repo.Disciplina, as: :get_by_code
  defdelegate get_avaliacao_by_id(id, opts \\ []), to: Repo.Avaliacao, as: :get_by_id

  defdelegate change_avaliacao(attrs, scope),
    to: Avaliacoes.Entities.Avaliacao,
    as: :changeset

  defdelegate search_disciplinas(query),
    to: UspAvalia.Avaliacoes.UseCases.SearchDisciplinas,
    as: :call

  defdelegate can_open_pedido_verificacao?(scope),
    to: UspAvalia.Avaliacoes.UseCases.CanOpenPedidoVerificacao,
    as: :call
end
