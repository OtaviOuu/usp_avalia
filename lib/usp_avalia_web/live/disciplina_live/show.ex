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
      <div class="flex flex-col gap-8">
        <div class="card bg-base-100 shadow-xl p-6">
          <h1 class="text-3xl font-bold mb-3">
            Disciplina: {@disciplina.nome}
          </h1>

          <div class="text-lg mb-4">
            <span class="badge badge-outline text-base">{@disciplina.codigo}</span>
          </div>

          <div class="prose max-w-none">
            Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui
            Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui
            Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui
            Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui
            Detalhes da disciplina aqui Detalhes da disciplina aqui Detalhes da disciplina aqui
          </div>
        </div>

        <div class="card bg-base-100 shadow-xl p-6">
          <h2 class="text-2xl font-semibold mb-4">
            Professores que ministram {@disciplina.codigo}
          </h2>
          <form phx-change="search_professores" class="mb-4">
            <label class="input input-bordered">
              <.icon name="hero-magnifying-glass" class="icon-sm" />
              <input type="search" name="value" required placeholder="Search" />
            </label>
          </form>
          <.professores_table professores={@professores} codigo={@disciplina.codigo} />
        </div>
      </div>
    </Layouts.app>
    """
  end

  def handle_event("search_professores", %{"value" => value}, socket) do
    codigo = socket.assigns.disciplina.codigo

    professores =
      Avaliacoes.search_professores(value, codigo)

    {:noreply, assign(socket, :professores, professores)}
  end

  attr :professores, :list, required: true
  attr :codigo, :string, required: true

  def professores_table(assigns) do
    ~H"""
    <div class="overflow-x-auto w-full">
      <table class="table table-zebra">
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
            class="hover:bg-base-200 hover:cursor-pointer"
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
