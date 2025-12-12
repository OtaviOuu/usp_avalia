defmodule UspAvalia.ProfilesVerifications.UseCases.CreatePedidoVerificacao do
  import Ecto.Query, warn: false
  alias UspAvalia.Repo

  alias UspAvalia.ProfilesVerifications.Entities.PedidoVerificacao
  alias UspAvalia.Accounts.Scope

  def call(attrs, %Scope{} = scope) do
    PedidoVerificacao.changeset(attrs, scope)
    |> Repo.insert()
  end
end
