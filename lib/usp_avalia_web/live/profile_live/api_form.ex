defmodule UspAvaliaWeb.ProfileLive.ApiForm do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Accounts

  on_mount {UspAvaliaWeb.UserAuth, :mount_current_scope}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :api_token, nil) |> assign(:ms_until_next_window, nil)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="max-w-xl mx-auto px-4 py-8 space-y-6">
        <header class="space-y-1">
          <h1 class="text-2xl font-bold">Gerar token para acessar a API</h1>
        </header>

        <div :if={@ms_until_next_window} class="rounded-lg border px-4 py-3 border-red-500 bg-red-50">
          <p class="text-red-700">
            Você atingiu o limite de geração de tokens. Tente novamente em <strong> {div(@ms_until_next_window, 1000)} segundos</strong>.
          </p>
        </div>

        <div class="space-y-2">
          <div
            :if={@api_token}
            class={
            "rounded-lg border px-4 py-3 " <>
             "border-green-500 bg-green-50"
          }
          >
            <span class="font-mono break-all text-green-700">{@api_token}</span>
          </div>
        </div>

        <div>
          <.button
            phx-click="get_api_token"
            phx-disable-with="Gerando..."
            class="flex items-center gap-2"
          >
            <.icon name="hero-key" class="w-4 h-4" /> Gerar novo token
          </.button>
        </div>
      </div>
    </Layouts.app>
    """
  end

  def handle_event("get_api_token", _params, socket) do
    scope = socket.assigns.current_scope

    case Accounts.create_user_api_token(scope.user) do
      {:ok, token} ->
        socket =
          socket
          |> assign(:api_token, token)

        {:noreply, socket}

      {:error, ms_until_next_window} ->
        IO.inspect(ms_until_next_window)

        socket =
          socket
          |> assign(:ms_until_next_window, ms_until_next_window)

        {:noreply, socket}
    end
  end
end
