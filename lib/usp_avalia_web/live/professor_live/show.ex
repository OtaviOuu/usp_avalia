defmodule UspAvaliaWeb.ProfessorLive.Show do
  alias UspAvalia.Avaliacoes
  use UspAvaliaWeb, :live_view

  def mount(%{"id" => id}, _session, socket) do
    {:ok, professor} = Avaliacoes.get_professor_by_id(id)

    {:ok,
     socket
     |> assign(:professor, professor)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <h1>Detalhes do Professor</h1>
      <div>
        <p><strong>Nome:</strong> {@professor.nome}</p>
        <p><strong>Salário:</strong> R$ {@professor.salario}</p>
        <p><strong>Número de Disciplinas:</strong> {@professor.numero_disciplinas}</p>
        <h2>Disciplinas Ministradas:</h2>
        <ul>
          <li :for={disciplina <- @professor.disciplinas}>
            {disciplina.nome} (Código: {disciplina.codigo})
          </li>
        </ul>
      </div>
    </Layouts.app>
    """
  end
end
