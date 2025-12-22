defmodule UspAvalia.Avaliacoes.UseCases.CreateAvaliacao do
  alias UspAvalia.Avaliacoes.Avaliacao

  alias UspAvalia.Repo
  alias UspAvalia.Accounts.Scope

  def call(%Scope{} = scope, avaliacao_attrs) do
    Repo.transact(fn ->
      Avaliacao.changeset(avaliacao_attrs, scope)
      |> Repo.insert()
    end)
  end
end
