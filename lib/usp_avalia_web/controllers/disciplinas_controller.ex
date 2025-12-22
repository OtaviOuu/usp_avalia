defmodule UspAvaliaWeb.DisciplinasController do
  use UspAvaliaWeb, :controller

  alias UspAvalia.Avaliacoes
  alias UspAvalia.Avaliacoes.Disciplina
  action_fallback UspAvaliaWeb.FallbackController

  def index(conn, _params) do
    disciplinas = Avaliacoes.list_disciplinas()
    render(conn, disciplinas: disciplinas)
  end

  def show(conn, %{"code" => code}) do
    with %Disciplina{} = disciplina <- Avaliacoes.get_disciplina_by_code(code) do
      render(conn, disciplina: disciplina)
    end

    {:error, :not_found}
  end
end
