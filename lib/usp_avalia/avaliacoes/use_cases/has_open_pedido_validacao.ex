defmodule UspAvalia.Avaliacoes.UseCases.HasOpenPedidoValidacao do
  alias UspAvalia.Accounts.Scope

  alias UspAvalia.ProfilesVerifications.Entities.PedidoVerificacao
  import Ecto.Query, warn: false
  alias UspAvalia.Repo

  def call(%Scope{} = scope) do
    PedidoVerificacao
    |> where([pv], pv.user_id == ^scope.user.id and pv.status == "pendente")
    |> Repo.one()
  end
end
