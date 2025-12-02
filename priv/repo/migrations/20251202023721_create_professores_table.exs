defmodule UspAvalia.Repo.Migrations.CreateProfessoresTable do
  use Ecto.Migration

  def change do
    create table(:professores, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :nome, :string
      add :email, :string
      add :salario, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
