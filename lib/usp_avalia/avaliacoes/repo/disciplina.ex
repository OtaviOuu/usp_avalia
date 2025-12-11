defmodule UspAvalia.Avaliacoes.Repo.Disciplina do
  use Ecto.Schema

  alias UspAvalia.Repo
  alias UspAvalia.Avaliacoes.Entities.Disciplina
  import Ecto.Query, warn: false

  def get_all(limit \\ 5) when is_integer(limit) do
    Disciplina
    |> limit(^limit)
    |> Repo.all()
  end

  def get_by_code(code) do
    Repo.get_by(Disciplina, codigo: code)
  end
end
