defmodule UspAvaliaWeb.DisciplinaLive.Avaliacao do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes
  import UspAvaliaWeb.Charts, only: [simple_pie_chart: 1]

  def mount(%{"codigo" => codigo, "professor_id" => professor_id}, _session, socket) do
    professor = Avaliacoes.get_professor_by_id(professor_id)
    disciplina = Avaliacoes.get_disciplina_by_code(codigo)

    socket =
      socket
      |> assign(:professor, professor)
      |> assign(:disciplina, disciplina)
      |> assign(:codigo, codigo)
      |> assign_avaliacoes

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="flex flex-col gap-6">
        <.card_professor_data
          current_scope={@current_scope}
          media={@avaliacoes_data.media_geral}
          quantidade_avaliacoes={@quantidade_avaliacoes}
          disciplina={@disciplina}
          professor={@professor}
        />

        <div class="card bg-base-100 shadow-xl p-6">
          <h2 class="text-2xl font-semibold mb-4">Gráficos</h2>
          <.graficos
            quantidade_negativos={@quantidade_negativos}
            quantidade_positivos={@quantidade_positivos}
          />
        </div>

        <div class="card bg-base-100 shadow-xl p-6">
          <h2 class="text-2xl font-semibold mb-4">Avaliações</h2>
          <.avaliacoes_table
            avaliacoes_data={@avaliacoes_data}
            professor={@professor}
            disciplina_code={@codigo}
          />
        </div>
      </div>
    </Layouts.app>
    """
  end

  attr :current_scope, :map, required: true
  attr :media, :float, required: true
  attr :quantidade_avaliacoes, :integer, required: true
  attr :disciplina, :map, required: true
  attr :professor, :map, required: true

  defp card_professor_data(assigns) do
    ~H"""
    <div class="card bg-base-100 shadow-xl p-6">
      <h1 class="text-3xl font-bold mb-4">Avaliação do Professor</h1>

      <p class="text-lg mb-2">
        <span class="font-semibold">{@disciplina.nome}</span>
        <span class="badge badge-outline ml-2">{@disciplina.codigo}</span>
      </p>

      <div class="stats  w-full bg-base-200">
        <div class="stat">
          <div class="stat-title">Nota média</div>
          <div class="stat-value">{@media |> Decimal.round(2)}</div>
        </div>

        <div class="stat">
          <div class="stat-title">Avaliações recebidas</div>
          <div class="stat-value">{@quantidade_avaliacoes}</div>
        </div>
      </div>

      <div class="mt-5">
        <.btn_avalliar
          current_scope={@current_scope}
          disciplina={@disciplina}
          professor={@professor}
        />
      </div>
    </div>
    """
  end

  attr :avaliacoes_data, :list, required: true
  attr :professor, :map, required: true
  attr :disciplina_code, :string, required: true

  defp avaliacoes_table(assigns) do
    ~H"""
    <div class="overflow-x-auto w-full">
      <table class="table">
        <thead>
          <tr>
            <th>Comentário</th>
            <th>Nota</th>
          </tr>
        </thead>

        <tbody>
          <tr
            :for={avaliacao <- @avaliacoes_data.avaliacoes}
            phx-click={
              JS.navigate(
                "/disciplinas/#{@disciplina_code}/professores/#{@professor.id}/avaliacoes/#{avaliacao.id}"
              )
            }
            class="hover:bg-base-200 hover:cursor-pointer"
          >
            <td>{avaliacao.comentario_avaliacao}</td>
            <td>{avaliacao.nota_avaliacao}</td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  defp graficos(assigns) do
    ~H"""
    <div class="grid grid-cols-3 gap-6">
      <.simple_pie_chart
        id="example-pie-chart"
        labels={["Positivo", "Negativo"]}
        series={[@quantidade_positivos, @quantidade_negativos]}
      />

      <.simple_pie_chart
        id="example-pie-chart"
        labels={["Positivo", "Negativo"]}
        series={[@quantidade_positivos, @quantidade_negativos]}
      />
      <.simple_pie_chart
        id="example-pie-chart"
        labels={["Positivo", "Negativo"]}
        series={[@quantidade_positivos, @quantidade_negativos]}
      />
    </div>
    """
  end

  attr :current_scope, :map, required: true
  attr :disciplina, :map, required: true
  attr :professor, :map, required: true

  defp btn_avalliar(assigns) do
    ~H"""
    <%= if Avaliacoes.can_create_avaliacao?(@current_scope) do %>
      <button
        class="btn btn-primary"
        phx-click={
          JS.navigate(~p"/disciplinas/#{@disciplina.codigo}/professores/#{@professor.id}/avaliar")
        }
      >
        Avaliar
      </button>
    <% else %>
      <p class="text-red-500">
        Você precisa ter um perfil verificado para avaliar este professor.
      </p>
    <% end %>
    """
  end

  defp assign_avaliacoes(%{assigns: %{professor: professor, disciplina: disciplina}} = socket) do
    avaliacoes_data =
      Avaliacoes.list_avaliacoes_by_code_and_professor(disciplina.id, professor.id)

    socket
    |> assign(:avaliacoes_data, avaliacoes_data)
    |> assign(:quantidade_avaliacoes, length(avaliacoes_data.avaliacoes))
    |> handle_charts_data(avaliacoes_data)
  end

  # botar na db kk
  defp handle_charts_data(socket, avaliacoes_data) do
    positivos =
      Enum.count(avaliacoes_data.avaliacoes, fn a -> (a.nota_avaliacao + a.nota_aula) / 2 >= 5 end)

    negativos =
      Enum.count(avaliacoes_data.avaliacoes, fn a -> (a.nota_avaliacao + a.nota_aula) / 2 < 5 end)

    socket
    |> assign(:quantidade_positivos, positivos)
    |> assign(:quantidade_negativos, negativos)
  end
end
