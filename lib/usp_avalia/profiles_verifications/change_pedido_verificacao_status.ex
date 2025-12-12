defmodule UspAvalia.ProfilesVerifications.ChangePedidoVerificacaoStatus do
  alias UspAvalia.ProfilesVerifications.PedidoVerificacao

  alias UspAvalia.Accounts.Scope
  alias UspAvalia.Repo

  def call(
        %PedidoVerificacao{} = pedido_verificacao,
        new_status,
        %Scope{} = scope
      ) do
    true = pedido_verificacao.user_id == scope.user.id

    with {:ok, updated_pedido = %PedidoVerificacao{}} <-
           pedido_verificacao
           |> PedidoVerificacao.changeset(%{status: new_status}, scope)
           |> Repo.update() do
      {:ok, updated_pedido}
    end
  end
end
