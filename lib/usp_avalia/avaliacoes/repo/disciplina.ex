defmodule UspAvalia.Avaliacoes.Repo.Disciplina do
  use Ecto.Schema

  alias UspAvalia.Repo
  alias UspAvalia.Avaliacoes.Entities.Disciplina

  def get_all do
    Disciplina
    |> Repo.all()
  end
end
