defmodule UspAvaliaWeb.ProfessorLive.Index do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes

  def mount(_params, _session, socket) do
    professores = Avaliacoes.list_professores()
    {:ok, assign(socket, professores: professores)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <h1>Professor</h1>
      <div class="overflow-x-auto">
        <.professores_table professores={@professores} />
      </div>
    </Layouts.app>
    """
  end

  attr :professores, :list, required: true, doc: "the list of professores"

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
            phx-click={JS.navigate(~p"/professores/#{professor.id}")}
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
