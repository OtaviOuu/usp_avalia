defmodule UspAvalia.ProfilesVerifications do
  alias UspAvalia.ProfilesVerifications

  defdelegate create_pedido_validacao(attrs, scope),
    to: ProfilesVerifications.CreatePedidoVerificacao,
    as: :call

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
