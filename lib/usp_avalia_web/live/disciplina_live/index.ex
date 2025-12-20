defmodule UspAvaliaWeb.DisciplinaLive.Index do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"q" => q}, _url, socket) do
    disciplinas = Avaliacoes.search_disciplinas(q)

    socket =
      socket
      |> assign(disciplinas: disciplinas)
      |> assign(query: q)

    {:noreply, socket}
  end

  def handle_params(_, _url, socket) do
    disciplinas = Avaliacoes.list_disciplinas()
    {:noreply, assign(socket, disciplinas: disciplinas, query: "")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="flex flex-col gap-6 ">
        <div class="card bg-base-100 shadow-xl p-6">
          <h1 class="text-2xl font-bold mb-4">Buscar Disciplinas</h1>

          <form phx-change="search" class="flex gap-2">
            <div class="relative w-full">
              <.input
                autocomplete="off"
                phx-debounce="100"
                type="text"
                name="q"
                value={@query}
                placeholder="Filtrar por nome ou código"
                class="input input-bordered w-full"
              />
            </div>
          </form>
        </div>

        <.disciplinas_table disciplinas={@disciplinas} />
      </div>
    </Layouts.app>
    """
  end

  attr :disciplinas, :list, required: true

  def disciplinas_table(assigns) do
    ~H"""
    <div class="card bg-base-100 shadow-xl p-4 overflow-x-auto">
      <%= if Enum.empty?(@disciplinas) do %>
        <p class="text-center italic">Nenhuma disciplina encontrada</p>
      <% else %>
        <table class="table w-full table-fixed">
          <thead>
            <tr class="text-base font-semibold">
              <th>Código</th>
              <th>Nome</th>
              <th>Instituto</th>
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
              <td>{disciplina.instituto}</td>
            </tr>
          </tbody>
        </table>
      <% end %>
    </div>
    """
  end

  def handle_event("search", %{"q" => ""}, socket) do
    socket =
      socket
      |> assign(query: "")
      |> push_patch(to: ~p"/disciplinas")

    {:noreply, socket}
  end

  def handle_event("search", %{"q" => q}, socket) when not is_nil(q) do
    q = String.trim(q) |> String.downcase()

    socket =
      socket
      |> assign(query: q)
      |> push_patch(to: ~p"/disciplinas?q=#{q}")

    {:noreply, socket}
  end
end
