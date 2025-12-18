defmodule UspAvaliaWeb.DisciplinaLive.Avaliacao do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes

  def mount(%{"codigo" => codigo, "professor_id" => professor_id}, _session, socket) do
    {:ok, professor} = Avaliacoes.get_professor_by_id(professor_id)
    disciplina = Avaliacoes.get_disciplina_by_code(codigo)

    avaliacoes =
      Avaliacoes.list_avaliacoes_by_code_and_professor(disciplina.id, professor.id)

    socket =
      socket
      |> assign(:professor, professor)
      |> assign(:disciplina, disciplina)
      |> assign(:avaliacoes, avaliacoes)
      |> assign(:quantidade_avaliacoes, length(avaliacoes))
      |> assign_nota_media(avaliacoes)
      |> assign(:codigo, codigo)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="flex flex-col gap-6">
        <div class="card bg-base-100 shadow-xl p-6">
          <h1 class="text-3xl font-bold mb-4">Avaliação do Professor</h1>

          <p class="text-lg mb-2">
            <span class="font-semibold">{@disciplina.nome}</span>
            <span class="badge badge-outline ml-2">{@disciplina.codigo}</span>
          </p>

          <div class="stats  w-full bg-base-200">
            <div class="stat">
              <div class="stat-title">Nota média</div>
              <div class="stat-value">{@nota_media}</div>
            </div>

            <div class="stat">
              <div class="stat-title">Avaliações recebidas</div>
              <div class="stat-value">{@quantidade_avaliacoes}</div>
            </div>
          </div>

          <div class="mt-5">
            <%= if Avaliacoes.can_create_avaliacao?(@current_scope) do %>
              <button
                class="btn btn-primary"
                phx-click={
                  JS.navigate(
                    ~p"/disciplinas/#{@disciplina.codigo}/professores/#{@professor.id}/avaliar"
                  )
                }
              >
                Avaliar
              </button>
            <% else %>
              <p class="text-red-500">
                Você precisa ter um perfil verificado para avaliar este professor.
              </p>
            <% end %>
          </div>
        </div>

        <div class="card bg-base-100 shadow-xl p-6">
          <h2 class="text-2xl font-semibold mb-4">Avaliações</h2>

          <.avaliacoes_table
            avaliacoes={@avaliacoes}
            professor={@professor}
            disciplina_code={@codigo}
          />
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp assign_nota_media(socket, avaliacoes) do
    nota_media =
      case avaliacoes do
        [] ->
          0.0

        _ ->
          total = Enum.reduce(avaliacoes, 0, fn a, acc -> acc + a.nota end)
          total / length(avaliacoes)
      end

    assign(socket, :nota_media, nota_media)
  end

  attr :avaliacoes, :list, required: true
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
            :for={avaliacao <- @avaliacoes}
            phx-click={
              JS.navigate(
                "/disciplinas/#{@disciplina_code}/professores/#{@professor.id}/avaliacoes/#{avaliacao.id}"
              )
            }
            class="hover:bg-base-200 hover:cursor-pointer"
          >
            <td>{avaliacao.comentario}</td>
            <td>{avaliacao.nota}</td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end
end
