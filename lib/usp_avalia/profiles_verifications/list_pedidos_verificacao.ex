defmodule UspAvalia.ProfilesVerifications.ListPedidosVerificacao do
  alias UspAvalia.Repo
  alias UspAvalia.Accounts.Scope
  alias UspAvalia.ProfilesVerifications.PedidoVerificacao

  def call(%Scope{user: %{is_admin: true}} = _scope) do
    {:ok, Repo.all(PedidoVerificacao)}
  end

  def call(_scope) do
    {:error, :unauthorized}
  end
end
