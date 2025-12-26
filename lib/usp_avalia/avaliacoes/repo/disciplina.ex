defmodule UspAvalia.Avaliacoes.Repo.Disciplina do
  use Ecto.Schema

  alias UspAvalia.Repo
  alias UspAvalia.Avaliacoes.Disciplina
  import Ecto.Query, warn: false

  def get_all(limit \\ 15) when is_integer(limit) do
    Disciplina
    |> limit(^limit)
    |> Repo.all()
  end

  def get_by_code(code) do
    Disciplina
    |> Repo.get_by(codigo: code)
    |> Repo.preload(:professores)
  end
end
