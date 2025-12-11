defmodule UspAvaliaWeb.DisciplinaLive.Avaliacao.Show do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes

  def mount(
        %{"codigo" => _codigo, "professor_id" => _professor_id, "avaliacao_id" => avaliacao_id},
        _session,
        socket
      ) do
    avaliacao = Avaliacoes.get_avaliacao_by_id(avaliacao_id, load: [:author])

    {:ok, assign(socket, :avaliacao, avaliacao)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="flex flex-col gap-8">
        <div class="card bg-base-100 shadow-xl p-6">
          <h1 class="text-3xl font-bold mb-4">Detalhes da Avaliação</h1>

          <div class="flex flex-col text-lg gap-2">
            <div>
              <span class="font-semibold">Nota:</span>
              <span class="badge badge-primary text-base ml-2">{@avaliacao.nota}</span>
            </div>

            <div>
              <span class="font-semibold">Comentário:</span>
              <p class="mt-1">{@avaliacao.comentario}</p>
            </div>

            <div>
              <span class="font-semibold">Autor:</span>
              <p class="mt-1">{@avaliacao.author.email}</p>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
