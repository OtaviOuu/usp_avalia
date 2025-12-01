defmodule UspAvaliaWeb.DisciplinasControllerTest do
  use UspAvaliaWeb.ConnCase

  describe "index/2" do
    test "lists all disciplinas", %{conn: conn} do
      response =
        conn
        |> get(~p"/api/disciplinas")
        |> json_response(200)
    end
  end
end
