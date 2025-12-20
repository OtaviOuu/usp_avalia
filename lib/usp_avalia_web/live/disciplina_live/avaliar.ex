defmodule UspAvaliaWeb.DisciplinaLive.Avaliar do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes
  alias UspAvalia.Avaliacoes.Entities.ProfessoreDisciplina

  alias UspAvalia.Avaliacoes
  on_mount {UspAvaliaWeb.UserAuth, :require_authenticated}

  def mount(%{"codigo" => codigo, "professor_id" => professor_id}, _session, socket) do
    professor_disciplina =
      Avaliacoes.Repo.ProfessorDisciplina.get_by_professor_and_disciplina(
        professor_id,
        codigo
      )

    change_avaliacao =
      Avaliacoes.change_avaliacao(
        %{},
        socket.assigns.current_scope
      )

    socket =
      socket
      |> assign(:disciplina, professor_disciplina.disciplina)
      |> assign(:professor, professor_disciplina.professor)
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
            type="textarea"
            label="Comentário Geral"
            field={@form_avaliacao[:comentario_geral]}
          />
          <.input
            type="number"
            label="Nota da Avaliação"
            field={@form_avaliacao[:nota_avaliacao]}
          />
          <.input
            type="textarea"
            label="Comentário da Avaliação"
            field={@form_avaliacao[:comentario_avaliacao]}
          />
          <.input
            type="number"
            label="Nota da Aula"
            field={@form_avaliacao[:nota_aula]}
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
      |> Map.put("disciplina_codigo", socket.assigns.disciplina.codigo)

    case Avaliacoes.create_avaliacao(scope, attrs) do
      {:ok, _avaliacao} ->
        socket =
          socket
          |> put_flash(:info, "Avaliação criada com sucesso!")
          |> push_navigate(
            to:
              ~p"/disciplinas/#{socket.assigns.disciplina.codigo}/professores/#{socket.assigns.professor.id}/"
          )

        {:noreply, socket}

      {:error, changeset} ->
        IO.inspect(changeset.errors, label: "Errors")

        socket =
          socket
          |> assign(:form_avaliacao, changeset |> to_form(action: :validate))
          |> put_flash(:error, "Erro ao criar avaliação. Vc é aluno usp?")

        {:noreply, socket}
    end
  end
end
