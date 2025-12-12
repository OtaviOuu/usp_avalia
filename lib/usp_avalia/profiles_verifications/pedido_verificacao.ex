defmodule UspAvalia.ProfilesVerifications.PedidoVerificacao do
  use Ecto.Schema
  import Ecto.Changeset
  @fields [:numero_usp, :status, :foto_carteirinha, :informacoes_adicionais]
  @status_values [:pendente, :aprovado, :rejeitado]
  @primary_key {:id, :binary_id, autogenerate: true}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "pedidos_verificacao" do
    field :numero_usp, :string
    field :foto_carteirinha, :string
    field :informacoes_adicionais, :string

    field :status, Ecto.Enum, values: @status_values, default: :pendente

    belongs_to :user, UspAvalia.Accounts.User

    timestamps()
  end

  def changeset(attrs, scope) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_inclusion(:status, @status_values)
    |> put_assoc(:user, scope.user)
  end
end
