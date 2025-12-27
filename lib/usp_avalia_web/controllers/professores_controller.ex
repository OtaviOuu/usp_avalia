defmodule UspAvaliaWeb.ProfessoresController do
  use UspAvaliaWeb, :controller

  alias UspAvalia.Avaliacoes
  action_fallback UspAvaliaWeb.FallbackController

  def index(conn, _params) do
    professores = Avaliacoes.list_professores()
    render(conn, professores: professores)
  end
end
