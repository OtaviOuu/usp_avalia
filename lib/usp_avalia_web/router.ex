defmodule UspAvaliaWeb.Router do
  alias UspAvaliaWeb.AvaliacoesLive
  use UspAvaliaWeb, :router

  import UspAvaliaWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {UspAvaliaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UspAvaliaWeb do
    pipe_through :browser
  end

  scope "/api", UspAvaliaWeb do
    pipe_through :api

    get "/disciplinas", DisciplinasController, :index
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:usp_avalia, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: UspAvaliaWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", UspAvaliaWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{UspAvaliaWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/disciplinas", UspAvaliaWeb do
    pipe_through [:browser]

    live_session :disciplinas,
      on_mount: [{UspAvaliaWeb.UserAuth, :mount_current_scope}] do
      live "/", DisciplinaLive.Index, :index
      live "/:codigo", DisciplinaLive.Show, :show
      live "/:codigo/professores/:professor_id", DisciplinaLive.Avaliacao, :show
      live "/:codigo/professores/:professor_id/avaliar", DisciplinaLive.Avaliar

      live "/:codigo/professores/:professor_id/avaliacoes/:avaliacao_id",
           DisciplinaLive.Avaliacao.Show
    end
  end

  scope "/professores", UspAvaliaWeb do
    pipe_through [:browser]

    live_session :professores,
      on_mount: [{UspAvaliaWeb.UserAuth, :mount_current_scope}] do
      live "/", ProfessorLive.Index, :index
      live "/:id", ProfessorLive.Show, :show
    end
  end

  scope "/", UspAvaliaWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{UspAvaliaWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end
