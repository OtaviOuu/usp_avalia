defmodule UspAvaliaWeb.DisciplinasController do
  use UspAvaliaWeb, :controller

  alias UspAvalia.Avaliacoes

  action_fallback UspAvaliaWeb.FallbackController

  def index(conn, _params) do
    disciplinas = Avaliacoes.list_disciplinas()
    dbg(disciplinas)
    render(conn, disciplinas: disciplinas)
  end
end
