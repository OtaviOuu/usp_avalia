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
        preload: [:disciplinas],
        select_merge: %{
          id: p.id,
          nome: p.nome,
          email: p.email,
          salario: p.salario
        }

    query
    |> feed_numero_disciplinas()
    |> Repo.all()
  end

  def get_all do
    Professor
    |> preload(:disciplinas)
    |> feed_numero_disciplinas()
    |> Repo.all()
  end

  # fazer na db
  defp feed_numero_disciplinas(query) do
    from p in query,
      select_merge: %{
        numero_disciplinas:
          fragment(
            "(
            SELECT COUNT(*)
            FROM professores_disciplinas AS pd2
            WHERE pd2.professor_id = ?
          )",
            p.id
          )
      }
  end
end
