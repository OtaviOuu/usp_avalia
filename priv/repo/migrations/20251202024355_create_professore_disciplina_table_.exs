defmodule UspAvalia.Repo.Migrations.CreateProfessoreDisciplinaTable do
  use Ecto.Migration

  def change do
    create table(:professores_disciplinas, primary_key: false) do
      add :professor_id, references(:professores, type: :binary_id), null: false

      add :disciplina_codigo, references(:disciplinas, column: :codigo, type: :string),
        null: false
    end
  end
end
