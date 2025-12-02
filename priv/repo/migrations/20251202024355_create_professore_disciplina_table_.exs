defmodule UspAvalia.Repo.Migrations.CreateProfessoreDisciplinaTable do
  use Ecto.Migration

  def change do
    create table(:professores_disciplinas, primary_key: false) do
      add :professor_id, references(:professores, type: :binary_id), null: false

      add :disciplina_id, references(:disciplinas, type: :binary_id), null: false
    end
  end
end
