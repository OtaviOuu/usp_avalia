defmodule UspAvaliaWeb.DisciplinaLive.Index do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes

  def mount(_params, _session, socket) do
    disciplinas = Avaliacoes.list_disciplinas()

    {:ok, assign(socket, disciplinas: disciplinas)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <h1>Buscar Disciplinas</h1>
      <div class="overflow-x-auto">
        <.disciplinas_table disciplinas={@disciplinas} />
      </div>
    </Layouts.app>
    """
  end

  attr :disciplinas, :list, required: true, doc: "the list of disciplinas"

  def disciplinas_table(assigns) do
    ~H"""
    <div class="overflow-x-auto w-full">
      <table class="table">
        <thead>
          <tr>
            <th>Codigo</th>
            <th>Nome</th>
          </tr>
        </thead>
        <tbody>
          <tr
            :for={disciplina <- @disciplinas}
            phx-click={JS.navigate("/disciplinas/#{disciplina.codigo}")}
            class="hover:cursor-pointer hover:bg-base-200"
          >
            <td>{disciplina.codigo}</td>
            <td>{disciplina.nome}</td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end
end
