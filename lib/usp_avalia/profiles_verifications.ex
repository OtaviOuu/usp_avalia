defmodule UspAvalia.ProfilesVerifications do
  @behaviour Bodyguard.Policy

  def authorize(:create_pedido_validacao, %{user: %{verified: false}}, _), do: :ok
  def authorize(:create_pedido_validacao, _, _), do: :error

  alias UspAvalia.ProfilesVerifications

  def create_pedido_validacao(attrs, scope) do
    with :ok <- Bodyguard.permit(__MODULE__, :create_pedido_validacao, scope) do
      ProfilesVerifications.CreatePedidoVerificacao.call(attrs, scope)
    end
  end

  def can_create_pedido_validacao?(scope) do
    case Bodyguard.permit(__MODULE__, :create_pedido_validacao, scope) do
      :ok -> true
      _ -> false
    end
  end

  defdelegate list_pedidos_verificacao(scope),
    to: ProfilesVerifications.ListPedidosVerificacao,
    as: :call

  defdelegate change_pedido_validacao(attrs, scope),
    to: ProfilesVerifications.PedidoVerificacao,
    as: :changeset

  defdelegate change_pedido_verificacao_status(pedido_verificacao, new_status, scope),
    to: ProfilesVerifications.ChangePedidoVerificacaoStatus,
    as: :call
end
