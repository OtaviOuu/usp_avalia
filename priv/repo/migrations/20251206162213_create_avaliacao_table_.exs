defmodule UspAvalia.Repo.Migrations.CreateAvaliacaoTable do
  use Ecto.Migration

  def change do
    create table(:avaliacoes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :nota, :integer, null: false
      add :comentario, :text
      add :author_id, references(:users), null: false
      add :professor_id, references(:professores, type: :binary_id), null: false
      add :disciplina_id, references(:disciplinas, type: :binary_id), null: false

      timestamps()
    end
  end
end
