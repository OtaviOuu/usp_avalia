defmodule UspAvalia.ProfilesVerifications.PedidoVerificacao do
  use Ecto.Schema
  import Ecto.Changeset

  alias UspAvalia.Accounts.Scope

  @fields [:numero_usp, :status, :foto_carteirinha, :informacoes_adicionais]
  @update_fields [:status]
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

  def changeset(%__MODULE__{} = pedido_verificacao, attrs, %Scope{} = _scope) do
    pedido_verificacao
    |> cast(attrs, @update_fields)
    |> validate_required(@update_fields)
    |> validate_inclusion(:status, @status_values)
    |> validate_user(pedido_verificacao.user_id)
  end

  def changeset(attrs, scope) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_inclusion(:status, @status_values)
    |> put_assoc(:user, scope.user)
  end

  defp validate_user(changeset, user_id) do
    IO.inspect(changeset)

    if get_field(changeset, :user_id) == user_id do
      changeset
    else
      add_error(changeset, :user_id, "não autorizado")
    end
  end
end
