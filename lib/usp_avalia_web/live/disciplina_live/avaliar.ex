defmodule UspAvaliaWeb.DisciplinaLive.Avaliar do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes

  on_mount {UspAvaliaWeb.UserAuth, :require_authenticated}

  def mount(%{"codigo" => codigo, "professor_id" => professor_id}, _session, socket) do
    {:ok, professor} = Avaliacoes.get_professor_by_id(professor_id)
    disciplina = Avaliacoes.get_disciplina_by_code(codigo)

    change_avaliacao =
      Avaliacoes.change_avaliacao(
        %{},
        socket.assigns.current_scope
      )

    socket =
      socket
      |> assign(:disciplina, disciplina)
      |> assign(:professor, professor)
      |> assign(:form_avaliacao, change_avaliacao |> to_form(as: :avaliacao))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <h1>Disciplina: {@disciplina.codigo}</h1>
      <h1>Professor: {@professor.nome}</h1>
      <.form for={@form_avaliacao} phx-submit="save">
        <.input
          field={@form_avaliacao[:nota]}
          type="number"
          min="0"
          max="10"
          step="1"
          label="Nota"
        />
        <.input field={@form_avaliacao[:comentario]} type="textarea" label="Comentário" rows="10" />
        <.button type="submit">Enviar Avaliação</.button>
      </.form>
    </Layouts.app>
    """
  end

  def handle_event("save", %{"avaliacao" => avaliacao_params}, socket) do
    scope = socket.assigns.current_scope

    attrs =
      avaliacao_params
      |> Map.put("professor_id", socket.assigns.professor.id)
      |> Map.put("disciplina_id", socket.assigns.disciplina.id)

    IO.inspect(attrs)

    case Avaliacoes.create_avaliacao(scope, attrs) do
      {:ok, _avaliacao} ->
        socket =
          socket
          |> put_flash(:info, "Avaliação criada com sucesso!")
          |> push_navigate(to: ~p"/disciplinas/#{socket.assigns.disciplina.codigo}")

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(:form_avaliacao, changeset |> to_form())

        {:noreply, socket}
    end
  end
end
