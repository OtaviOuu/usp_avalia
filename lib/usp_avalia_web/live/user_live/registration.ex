defmodule UspAvaliaWeb.UserLive.Registration do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Accounts
  alias UspAvalia.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="min-h-[80vh] flex items-center justify-center px-4">
        <div class="w-full max-w-sm rounded-xl border border-zinc-200 bg-white shadow-sm p-6 space-y-6">
          <div class="text-center space-y-2">
            <.header>
              <p class="text-2xl font-semibold">
                Registrar uma nova conta
              </p>
              <:subtitle>
                <span class="text-sm text-zinc-500">
                  Já possui uma conta?
                  <.link
                    navigate={~p"/users/log-in"}
                    class="font-medium text-brand hover:underline"
                  >
                    Entrar
                  </.link>
                  agora.
                </span>
              </:subtitle>
            </.header>
          </div>

          <div class="flex justify-center pt-2">
            <.google_auth_button />
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: UspAvaliaWeb.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_email(%User{}, %{}, validate_unique: false)

    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_login_instructions(
            user,
            &url(~p"/users/log-in/#{&1}")
          )

        {:noreply,
         socket
         |> put_flash(
           :info,
           "An email was sent to #{user.email}, please access it to confirm your account."
         )
         |> push_navigate(to: ~p"/users/log-in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_email(%User{}, user_params, validate_unique: false)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end
