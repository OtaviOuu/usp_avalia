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
        <div class="flex flex-col items-center gap-8">
          <div class="grid grid-cols-1 sm:grid-cols-5 gap-20 card bg-base-100 shadow-xl p-10">
            <div :for={_professor <- 1..10} class="flex gap-4">
              <div class="avatar">
                <div class="w-24 rounded-full">
                  <img src="https://img.daisyui.com/images/profile/demo/yellingcat@192.webp" />
                </div>
              </div>

              <div class="flex flex-col gap-2">
                <h3 class="font-bold">Tom Lowry</h3>

                <span class="text-sm">UI/UX Designer</span>

                <div class="flex text-accent text-xs">
                  <a class="btn btn-ghost btn-sm btn-circle">
                    <.icon name="hero-link" class="size-5" />
                  </a>

                  <a class="btn btn-ghost btn-sm btn-circle">
                    <.icon name="hero-link" class="size-5" />
                  </a>

                  <a class="btn btn-ghost btn-sm btn-circle">
                    <.icon name="hero-link" class="size-5" />
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
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
