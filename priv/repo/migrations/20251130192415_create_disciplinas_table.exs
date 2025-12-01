defmodule UspAvalia.Repo.Migrations.CreateDisciplinasTable do
  use Ecto.Migration

  def change do
    create table(:disciplinas, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :codigo, :string, null: false
      add :nome, :string, null: false
      add :instituto, :string, null: false

      add :inserted_at, :utc_datetime, null: false, default: fragment("now()")
      add :updated_at, :utc_datetime, null: false, default: fragment("now()")
    end
  end
end
