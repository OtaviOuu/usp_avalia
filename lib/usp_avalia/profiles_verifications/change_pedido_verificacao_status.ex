defmodule UspAvalia.ProfilesVerifications.ChangePedidoVerificacaoStatus do
  alias UspAvalia.ProfilesVerifications.PedidoVerificacao

  alias UspAvalia.Accounts.Scope
  alias UspAvalia.Repo

  def call(
        %PedidoVerificacao{} = pedido_verificacao,
        :aprovado = status,
        %Scope{} = scope
      ) do
    Repo.transact(fn ->
      update_pedido_and_user_verified_status(pedido_verificacao, status, scope)
    end)
  end

  def call(
        %PedidoVerificacao{} = pedido_verificacao,
        :rejeitado = status,
        %Scope{} = scope
      ) do
    Repo.transact(fn ->
      update_pedido_and_user_verified_status(pedido_verificacao, status, scope)
    end)
  end

  def call(_, _, _), do: {:error, :invalid_parameters}

  defp update_pedido_and_user_verified_status(pedido_verificacao, status, scope) do
    true = pedido_verificacao.user_id == scope.user.id

    with {:ok, updated_pedido = %PedidoVerificacao{}} <-
           pedido_verificacao
           |> PedidoVerificacao.changeset(%{status: status}, scope)
           |> Repo.update() do
      # alterar campo no user para verificado = true
      {:ok, updated_pedido}
    end
  end
end
