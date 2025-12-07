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
      <.table id="avaliacoes" rows={@avaliacoes}>
        <:col :let={avaliacao} label="comentario">{avaliacao.comentario}</:col>
        <:col :let={avaliacao} label="nota">{avaliacao.nota}</:col>
      </.table>
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
end
