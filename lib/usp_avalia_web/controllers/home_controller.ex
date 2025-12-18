defmodule UspAvaliaWeb.HomeController do
  use UspAvaliaWeb, :controller

  def redirect_to_disciplinas(conn, _params) do
    redirect(conn, to: ~p"/disciplinas")
  end
end
