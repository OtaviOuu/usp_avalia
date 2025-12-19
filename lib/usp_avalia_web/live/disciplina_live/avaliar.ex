defmodule UspAvaliaWeb.DisciplinaLive.Avaliar do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes

  on_mount {UspAvaliaWeb.UserAuth, :require_authenticated}

  def mount(%{"codigo" => codigo, "professor_id" => professor_id}, _session, socket) do
    professor = Avaliacoes.get_professor_by_id(professor_id)
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
      <div class="mt-6 w-full mx-auto max-w-lg bg-white p-6 rounded-lg shadow-md">
        <h1 class="text-xl font-semibold mb-4 text-center">
          {@disciplina.codigo} - {@professor.nome}
        </h1>
        <.form for={@form_avaliacao} phx-submit="save">
          <.input
            type="number"
            label="Nota da Avaliação"
            min="0"
            max="10"
            field={@form_avaliacao[:nota_avaliacao]}
            required
          />
          <.input
            type="textarea"
            label="Comentário da Avaliação"
            name="comentario_avaliacao"
            field={@form_avaliacao[:comentario_avaliacao]}
          />
          <.input
            type="number"
            label="Nota da Aula"
            min="0"
            max="10"
            field={@form_avaliacao[:nota_aula]}
            required
          />
          <.input
            type="textarea"
            label="Comentário da Aula"
            field={@form_avaliacao[:comentario_aula]}
          />
          <.input
            type="checkbox"
            label="Cobra Presença?"
            field={@form_avaliacao[:cobra_presenca?]}
          />
          <.input
            type="textarea"
            label="Comentário sobre Cobrança de Presença"
            field={@form_avaliacao[:comentario_cobra_presenca]}
          />
          <.button type="submit">Enviar Avaliação</.button>
        </.form>
      </div>
    </Layouts.app>
    """
  end

  def handle_event("save", %{"avaliacao" => avaliacao_params}, socket) do
    scope = socket.assigns.current_scope

    attrs =
      avaliacao_params
      |> Map.put("professor_id", socket.assigns.professor.id)
      |> Map.put("disciplina_id", socket.assigns.disciplina.id)

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
          |> put_flash(:error, "Erro ao criar avaliação. Vc é aluno usp?")

        {:noreply, socket}
    end
  end
end
