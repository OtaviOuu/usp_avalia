defmodule UspAvaliaWeb.DisciplinaLive.Index do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes

  def mount(_params, _session, socket) do
    disciplinas = Avaliacoes.list_disciplinas()

    {:ok, assign(socket, disciplinas: disciplinas, query: "")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="flex flex-col gap-6">
        <div class="card bg-base-100 shadow-xl p-6">
          <h1 class="text-2xl font-bold mb-4">Buscar Disciplinas</h1>

          <form phx-change="search" class="flex gap-2">
            <input
              type="text"
              name="q"
              value={@query}
              placeholder="Filtrar por nome ou código"
              class="input input-bordered w-full"
            />
          </form>
        </div>

        <div class="card bg-base-100 shadow-xl p-4 overflow-x-auto">
          <.disciplinas_table disciplinas={@disciplinas} />
        </div>
      </div>
    </Layouts.app>
    """
  end

  attr :disciplinas, :list, required: true

  def disciplinas_table(assigns) do
    ~H"""
    <table class="table w-full">
      <thead>
        <tr class="text-base font-semibold">
          <th>Código</th>
          <th>Nome</th>
        </tr>
      </thead>

      <tbody>
        <tr
          :for={disciplina <- @disciplinas}
          phx-click={JS.navigate("/disciplinas/#{disciplina.codigo}")}
          class="hover:bg-base-200 hover:cursor-pointer"
        >
          <td class="font-mono">{disciplina.codigo}</td>
          <td>{disciplina.nome}</td>
        </tr>
      </tbody>
    </table>
    """
  end

  def handle_event("search", %{"q" => q}, socket) do
    {:noreply, socket}
  end
end
