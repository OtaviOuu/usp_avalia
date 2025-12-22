defmodule UspAvalia.Avaliacoes.Repo.Professor do
  alias UspAvalia.Avaliacoes.Professor
  alias UspAvalia.Repo
  import Ecto.Query

  def get_by_id(id) do
    Professor
    |> Repo.get(id)
    |> Repo.preload(:disciplinas)
  end

  def get_all_by_disciplina_codigo(codigo) do
    query =
      from p in Professor,
        join: d in assoc(p, :disciplinas),
        where: d.codigo == ^codigo,
        preload: [:disciplinas]

    query
    |> Repo.all()
    |> feed_numero_disciplinas()
  end

  def get_all do
    Professor
    |> preload(:disciplinas)
    |> Repo.all()
    |> feed_numero_disciplinas()
  end

  # fazer na db
  defp feed_numero_disciplinas(professores) do
    Enum.map(professores, fn professor ->
      numero_disciplinas = length(professor.disciplinas || [])
      Map.put(professor, :numero_disciplinas, numero_disciplinas)
    end)
  end
end
