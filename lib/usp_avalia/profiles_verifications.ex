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
end
