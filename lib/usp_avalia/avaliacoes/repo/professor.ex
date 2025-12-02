defmodule UspAvalia.Avaliacoes.Repo.Professor do
  alias UspAvalia.Avaliacoes.Entities.Professor
  alias UspAvalia.Repo
  import Ecto.Query

  def get_by_id(id) do
    case Repo.get(Professor, id) do
      nil ->
        {:error, :not_found}

      professor ->
        professor = Repo.preload(professor, :disciplinas)
        {:ok, professor}
    end
  end

  def get_all do
    Professor
    |> preload(:disciplinas)
    |> Repo.all()
    |> feed_numero_disciplinas()
  end

  defp feed_numero_disciplinas(professores) do
    Enum.map(professores, fn professor ->
      numero_disciplinas = length(professor.disciplinas || [])
      Map.put(professor, :numero_disciplinas, numero_disciplinas)
    end)
  end
end
