defmodule UspAvaliaWeb.ProfessorDisciplinaController do
  use UspAvaliaWeb, :controller
  alias UspAvalia.Avaliacoes
  require Logger

  action_fallback UspAvaliaWeb.FallbackController

  def show(conn, %{"code" => disciplina_codigo, "professor_id" => professor_id}) do
    Logger.info(
      "Fetching avaliacoes for disciplina #{disciplina_codigo} and professor #{professor_id}"
    )

    with %{avaliacoes: avaliacoes} <-
           Avaliacoes.list_avaliacoes_by_code_and_professor(disciplina_codigo, professor_id) do
      render(conn, avaliacoes: avaliacoes)
    end
  end
end
