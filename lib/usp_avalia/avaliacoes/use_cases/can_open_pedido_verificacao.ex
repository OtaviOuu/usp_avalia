defmodule UspAvalia.Avaliacoes.UseCases.CanOpenPedidoVerificacao do
  alias UspAvalia.Accounts.Scope

  alias UspAvalia.ProfilesVerifications.Entities.PedidoVerificacao
  import Ecto.Query, warn: false
  alias UspAvalia.Repo

  @statuses_abertos ~w(pendente rejeitado)

  # ruim

  @doc """
  Verifica se o usuário pode abrir um novo pedido de verificação de perfil.
  Um usuário pode abrir um novo pedido se não houver pedidos pendentes ou rejeitados.
  Retorna {:ok, true} se puder abrir, {:ok, false, pedido} se não puder, junto com o pedido existente.
  """

  def call(%Scope{} = scope) do
    query =
      from pv in PedidoVerificacao,
        where: pv.user_id == ^scope.user.id and pv.status != "rejeitado"

    case Repo.one(query) do
      nil -> {:ok, true}
      pedido -> {:ok, false, pedido}
    end
  end
end
