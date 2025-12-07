defmodule UspAvaliaWeb.DisciplinaLive.Avaliacao.Show do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes

  def mount(
        %{"codigo" => _codigo, "professor_id" => _professor_id, "avaliacao_id" => avaliacao_id},
        _session,
        socket
      ) do
    avaliacao = Avaliacoes.get_avaliacao_by_id(avaliacao_id, load: [:author])

    socket =
      socket
      |> assign(:avaliacao, avaliacao)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <h1>Detalhes da Avaliação</h1>
      <p>Aqui estarão os detalhes da avaliação selecionada.</p>

      <h1>{@avaliacao.nota}</h1>
      <h1>{@avaliacao.comentario}</h1>
      <p>{@avaliacao.author.email}</p>
    </Layouts.app>
    """
  end
end
