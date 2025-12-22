defmodule UspAvalia.Avaliacoes.Repo.Avaliacao do
  alias UspAvalia.Repo
  alias UspAvalia.Avaliacoes.Avaliacao
  import Ecto.Query

  def get_by_id(id, opts) do
    Avaliacao
    |> Repo.get_by(id: id)
    |> handle_preload(opts)
  end

  def list_by_code_and_professor(disciplina_codigo, professor_id) do
    base_query =
      from a in Avaliacao,
        where:
          a.disciplina_codigo == ^disciplina_codigo and
            a.professor_id == ^professor_id

    avaliacoes =
      Repo.all(
        from a in base_query,
          select: a
      )

    media_geral =
      Repo.one(
        from a in base_query,
          select: avg((a.nota_avaliacao + a.nota_aula) / 2)
      )

    %{
      avaliacoes: avaliacoes,
      media_geral: media_geral
    }
  end

  defp handle_preload(query_result, opts) do
    preload = Keyword.get(opts, :load, [])

    Repo.preload(query_result, preload)
  end
end
