defmodule UspAvalia.Repo.Migrations.AddPedidosVerificacaoTable do
  use Ecto.Migration

  def change do
    create table(:pedidos_verificacao, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :numero_usp, :string, null: false
      add :status, :string, null: false, default: "pendente"
      add :foto_carteirinha, :string, null: false
      add :informacoes_adicionais, :text, null: false
      add :user_id, references(:users, type: :bigint), null: false

      timestamps()
    end
  end
end

1
