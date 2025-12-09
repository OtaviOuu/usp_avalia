defmodule UspAvalia.ProfilesVerifications.Entities.PedidoVerificacao do
  use Ecto.Schema
  import Ecto.Changeset
  @fields [:numero_usp, :status, :user_id]
  @status_values ["pendente", "aprovado", "rejeitado"]
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "pedidos_verificacao" do
    field :numero_usp, :string
    field :status, :string, default: "pendente"

    belongs_to :user, UspAvalia.Accounts.User

    timestamps()
  end

  def changeset(pedido_verificacao, attrs) do
    pedido_verificacao
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_inclusion(:status, @status_values)
  end
end
