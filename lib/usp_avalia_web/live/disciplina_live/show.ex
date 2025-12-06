defmodule UspAvaliaWeb.DisciplinaLive.Show do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes

  def mount(%{"codigo" => codigo}, _session, socket) do
    socket =
      socket
      |> assign(:codigo, codigo)
      |> assign(:professores, Avaliacoes.list_professores_by_disciplina_codigo(codigo))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <h1>Professores de <b>{@codigo}</b></h1>
      <.professores_table professores={@professores} codigo={@codigo} />
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
            phx-click={JS.navigate(~p"/disciplinas/#{@codigo}/#{professor.id}/avaliar")}
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
