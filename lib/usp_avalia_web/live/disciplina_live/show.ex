defmodule UspAvaliaWeb.DisciplinaLive.Show do
  use UspAvaliaWeb, :live_view

  def mount(%{"codigo" => codigo}, _session, socket) do
    {:ok, assign(socket, codigo: codigo)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <h1>Professores:</h1>
    </Layouts.app>
    """
  end
end
