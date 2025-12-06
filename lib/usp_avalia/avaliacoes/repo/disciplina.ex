defmodule UspAvalia.Avaliacoes.Repo.Disciplina do
  use Ecto.Schema

  alias UspAvalia.Repo
  alias UspAvalia.Avaliacoes.Entities.Disciplina

  def get_all do
    Disciplina
    |> Repo.all()
  end

  def get_by_code(code) do
    Repo.get_by(Disciplina, codigo: code)
  end
end
