defmodule UspAvaliaWeb.PageController do
  use UspAvaliaWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
