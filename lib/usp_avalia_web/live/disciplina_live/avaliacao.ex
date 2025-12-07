defmodule UspAvaliaWeb.DisciplinaLive.Avaliacao do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes

  def mount(%{"codigo" => codigo, "professor_id" => professor_id}, _session, socket) do
    {:ok, professor} = Avaliacoes.get_professor_by_id(professor_id)
    disciplina = Avaliacoes.get_disciplina_by_code(codigo)

    avaliacoes = Avaliacoes.list_avaliacoes_by_code_and_professor(disciplina.id, professor.id)

    socket =
      socket
      |> assign(:professor, professor)
      |> assign(:disciplina, disciplina)
      |> assign(:avaliacoes, avaliacoes)
      |> assign_nota_media(avaliacoes)
      |> assign(:codigo, codigo)
      # bad :(
      |> assign(:quantidade_avaliacoes, length(avaliacoes))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <h1>Avaliação de professor</h1>

      <div class="stats shadow">
        <div class="stat">
          <div class="stat-title">Nota média</div>
          <div class="stat-value">{@nota_media}</div>
        </div>
      </div>
      <div class="stats shadow">
        <div class="stat">
          <div class="stat-title">Quantas vezes avaliado</div>
          <div class="stat-value">{@quantidade_avaliacoes}</div>
        </div>
      </div>
      <p>{@disciplina.nome} ({@disciplina.codigo})</p>
      <.button phx-click={
        JS.navigate(~p"/disciplinas/#{@disciplina.codigo}/professores/#{@professor.id}/avaliar")
      }>
        avaliar
      </.button>
      <.avaliacoes_table avaliacoes={@avaliacoes} professor={@professor} disciplina_code={@codigo} />
    </Layouts.app>
    """
  end

  # baaaaaaaaaaaaaaad
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
            class="hover:cursor-pointer hover:bg-base-200"
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
