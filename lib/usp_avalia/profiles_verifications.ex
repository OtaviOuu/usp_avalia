defmodule UspAvalia.ProfilesVerifications do
  alias UspAvalia.ProfilesVerifications

  defdelegate create_pedido_validacao(attrs, scope),
    to: ProfilesVerifications.UseCases.CreatePedidoVerificacao,
    as: :call

  defdelegate list_pedidos_verificacao(scope),
    to: ProfilesVerifications.UseCases.ListPedidosVerificacao,
    as: :call
end
