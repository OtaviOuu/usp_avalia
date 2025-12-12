defmodule UspAvalia.ProfilesVerifications.UseCases.ListPedidosVerificacao do
  import Ecto.Query
  alias UspAvalia.Repo
  alias UspAvalia.Accounts.Scope
  alias UspAvalia.ProfilesVerifications.Entities.PedidoVerificacao

  def call(%Scope{user: %{is_admin: true}} = scope) do
    {:ok, Repo.all(PedidoVerificacao)}
  end

  def call(_scope) do
    {:error, :unauthorized}
  end
end
