defmodule UspAvalia.Repo.Migrations.CreateDisciplinasTable do
  use Ecto.Migration

  def change do
    create table(:disciplinas, primary_key: false) do
      add :codigo, :string, primary_key: true
      add :nome, :string, null: false
      add :instituto, :string, null: false

      add :inserted_at, :utc_datetime, null: false, default: fragment("now()")
      add :updated_at, :utc_datetime, null: false, default: fragment("now()")
    end
  end
end
