defmodule UspAvalia.Avaliacoes.SearchDisciplinas do
  import Ecto.Query, warn: false
  alias UspAvalia.Repo

  alias UspAvalia.Avaliacoes.Disciplina

  def call(query) when is_binary(query) do
    query_downcased = String.downcase(query)

    Disciplina
    |> where(
      [d],
      ilike(fragment("LOWER(?)", d.nome), ^"%#{query_downcased}%") or
        ilike(fragment("LOWER(?)", d.codigo), ^"%#{query_downcased}%") or
        ilike(fragment("LOWER(?)", d.instituto), ^"%#{query_downcased}%")
    )
    |> limit(15)
    |> Repo.all()
  end
end
