defmodule UspAvaliaWeb.UserLive.Login do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="min-h-[80vh] flex items-center justify-center px-4">
        <div class="w-full max-w-sm rounded-xl border border-zinc-200 bg-white shadow-sm p-6 space-y-6">
          <div class="text-center space-y-1">
            <.header>
              <p class="text-2xl font-semibold">Log in</p>
              <:subtitle>
                <%= if @current_scope do %>
                  <span class="text-sm text-zinc-500">
                    You need to reauthenticate to perform sensitive actions on your account.
                  </span>
                <% else %>
                  <span class="text-sm text-zinc-500">
                    Não possui uma conta? <.link
                      navigate={~p"/users/register"}
                      class="font-medium text-brand hover:underline"
                      phx-no-format
                    >
                      Registrar
                    </.link> agora.
                  </span>
                <% end %>
              </:subtitle>
            </.header>
          </div>

          <div
            :if={local_mail_adapter?()}
            class="flex gap-3 rounded-lg bg-blue-50 p-4 text-sm text-blue-700"
          >
            <.icon name="hero-information-circle" class="size-5 shrink-0" />
            <div class="space-y-1">
              <p class="font-medium">Local mail adapter ativo</p>
              <p>
                Veja os emails enviados em <.link href="/dev/mailbox" class="underline">
                  mailbox
                </.link>.
              </p>
            </div>
          </div>

          <div class="flex justify-center">
            <.google_auth_button />
          </div>

          <div class="flex items-center gap-3">
            <div class="h-px flex-1 bg-zinc-200"></div>
            <span class="text-xs uppercase text-zinc-400">ou</span>
            <div class="h-px flex-1 bg-zinc-200"></div>
          </div>

          <.form
            :let={f}
            for={@form}
            id="login_form_password"
            action={~p"/users/log-in"}
            phx-submit="submit_password"
            phx-trigger-action={@trigger_submit}
            class="space-y-4"
          >
            <.input
              readonly={!!@current_scope}
              field={f[:email]}
              type="email"
              label="Email"
              autocomplete="email"
              required
            />

            <.input
              field={@form[:password]}
              type="password"
              label="Password"
              autocomplete="current-password"
            />

            <div class="space-y-2 pt-2">
              <.button
                class="btn btn-primary w-full"
                name={@form[:remember_me].name}
                value="true"
              >
                Log in and stay logged in
              </.button>

              <.button class="btn btn-ghost w-full">
                Log in only this time
              </.button>
            </div>
          </.form>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    email =
      Phoenix.Flash.get(socket.assigns.flash, :email) ||
        get_in(socket.assigns, [:current_scope, Access.key(:user), Access.key(:email)])

    form = to_form(%{"email" => email}, as: "user")

    {:ok, assign(socket, form: form, trigger_submit: false)}
  end

  @impl true
  def handle_event("submit_password", _params, socket) do
    {:noreply, assign(socket, :trigger_submit, true)}
  end

  def handle_event("submit_magic", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_login_instructions(
        user,
        &url(~p"/users/log-in/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions for logging in shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> push_navigate(to: ~p"/users/log-in")}
  end

  defp local_mail_adapter? do
    Application.get_env(:usp_avalia, UspAvalia.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
