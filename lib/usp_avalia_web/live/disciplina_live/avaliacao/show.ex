defmodule UspAvaliaWeb.DisciplinaLive.Avaliacao.Show do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes

  import UspAvaliaWeb.Charts

  def mount(
        %{"codigo" => _codigo, "professor_id" => _professor_id, "avaliacao_id" => avaliacao_id},
        _session,
        socket
      ) do
    avaliacao =
      Avaliacoes.get_avaliacao_by_id(avaliacao_id, load: [:disciplina, :professor])

    {:ok, assign(socket, :avaliacao, avaliacao)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="flex flex-col gap-8">
        <div class="card bg-base-100 shadow-xl p-6">
          <p>
            disciplina: {@avaliacao.disciplina.codigo}
          </p>
          <p>
            professor: {@avaliacao.professor.nome}
          </p>
          <h1 class="text-3xl font-bold mb-4">Detalhes da Avaliação</h1>

          <div class="flex flex-col text-lg gap-2">
            <div>
              <span class="font-semibold">Notas:</span>
              <span class="badge badge-primary text-base ml-2">{@avaliacao.nota_avaliacao}</span>
              <span class="badge badge-primary text-base ml-2">{@avaliacao.nota_aula}</span>
              <span class="badge badge-primary text-base ml-2">
                {(@avaliacao.nota_avaliacao + @avaliacao.nota_aula) / 2}
              </span>
            </div>

            <div>
              <h1 class="font-semibold">Comentários:</h1>
              <p class="mt-1"><strong>Geral:</strong> {@avaliacao.comentario_geral}</p>
              <p class="mt-1"><strong>Avaliação:</strong> {@avaliacao.comentario_avaliacao}</p>
            </div>
          </div>
        </div>
        <.chart_card avaliacao={@avaliacao} />
      </div>
    </Layouts.app>
    """
  end

  defp chart_card(assigns) do
    ~H"""
    <div class="card bg-base-100 shadow-xl p-6">
      <.simple_column_chart
        id="chart-avaliacao"
        labels={["Nota da Avaliação", "Nota da Aula"]}
        series={[@avaliacao.nota_avaliacao, @avaliacao.nota_aula]}
        title="Notas da Avaliação"
      />
    </div>
    """
  end
end
