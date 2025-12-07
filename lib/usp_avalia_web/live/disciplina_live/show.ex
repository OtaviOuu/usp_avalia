defmodule UspAvaliaWeb.DisciplinaLive.Show do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes

  def mount(%{"codigo" => codigo}, _session, socket) do
    disciplina = Avaliacoes.get_disciplina_by_code(codigo)

    socket =
      socket
      |> assign(:disciplina, disciplina)
      |> assign(:professores, Avaliacoes.list_professores_by_disciplina_codigo(codigo))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <h1>Disciplina: <b>{@disciplina.nome}</b></h1>
      <h1>Professores de <b>{@disciplina.codigo}</b></h1>
      <div>
        Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui
      </div>

      <h1>Professores que dão essa disciplina:</h1>
      <div class="mx-auto">
        <.professores_table professores={@professores} codigo={@disciplina.codigo} />
      </div>
    </Layouts.app>
    """
  end

  def professores_table(assigns) do
    ~H"""
    <div class="overflow-x-auto w-full">
      <table class="table">
        <thead>
          <tr>
            <th>Nome</th>
            <th>Número de Disciplinas</th>
            <th>Salário</th>
          </tr>
        </thead>
        <tbody>
          <tr
            :for={professor <- @professores}
            phx-click={JS.navigate(~p"/disciplinas/#{@codigo}/professores/#{professor.id}")}
            class="hover:cursor-pointer hover:bg-base-200"
          >
            <td>{professor.nome}</td>
            <td>{professor.numero_disciplinas}</td>
            <td>R$ {professor.salario}</td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end
end
