defmodule UspAvaliaWeb.DisciplinaLive.Index do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes
  import UspAvaliaWeb.Charts

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :load_data, 500)
    end

    dataset = [
      %{
        name: "sales",
        data: [30, 40, 35, 50, 49, 60, 70, 91, 125]
      },
      %{
        name: "profit",
        data: [23, 27, 30, 38, 41, 47, 51, 58, 67]
      }
    ]

    {:ok, assign(socket, dataset: dataset)}
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
        <div class="card bg-base-100 shadow-xl p-6 grid grid-cols-1 md:grid-cols-3 gap-4">
          <.line_graph
            id="line-chart-1"
            height={420}
            width={640}
            dataset={@dataset}
            categories={[1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999]}
          />
          <.line_graph
            id="line-chart-2"
            height={420}
            width={640}
            dataset={@dataset}
            categories={[1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999]}
          />
          <.line_graph
            id="line-chart-3"
            height={420}
            width={640}
            dataset={@dataset}
            categories={[1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999]}
          />
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

  def handle_info(:load_data, socket) do
    new_dataset = [
      %{
        name: "sales",
        data: Enum.map(1..9, fn _ -> Enum.random(20..150) end)
      },
      %{
        name: "profit",
        data: Enum.map(1..9, fn _ -> Enum.random(15..80) end)
      }
    ]

    Process.send_after(self(), :load_data, 500)

    {:noreply,
     assign(socket, dataset: new_dataset) |> push_event("update-dataset", %{dataset: new_dataset})}
  end
end
