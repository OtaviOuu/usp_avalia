defmodule UspAvaliaWeb.OAuthController do
  alias UspAvaliaWeb.UserAuth
  alias UspAvalia.Accounts
  use UspAvaliaWeb, :controller
  require Logger

  plug Ueberauth

  def request(conn, _params) do
    Phoenix.Controller.redirect(conn, to: Ueberauth.Strategy.Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    email = auth.info.email

    case Accounts.get_user_by_email(email) do
      nil ->
        user_params = %{email: email}

        case Accounts.register_oauth_user(user_params) do
          {:ok, user} ->
            UserAuth.log_in_user(conn, user)

          {:error, changeset} ->
            Logger.error("Failed to create user #{inspect(changeset)}.")

            conn
            |> put_flash(:error, "Failed to create user.")
            |> redirect(to: ~p"/")
        end

      user ->
        UserAuth.log_in_user(conn, user)
    end
  end
end
