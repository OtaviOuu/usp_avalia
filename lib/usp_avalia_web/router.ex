defmodule UspAvaliaWeb.Router do
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
    plug :fetch_current_scope_for_api_user
  end

  scope "/api", UspAvaliaWeb do
    pipe_through :api

    get "/disciplinas", DisciplinasController, :index
    get "/disciplinas/:code", DisciplinasController, :show
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

  scope "/", UspAvaliaWeb do
    pipe_through [:browser]

    get "/", HomeController, :redirect_to_disciplinas

    scope "/professores" do
      live_session :professores,
        on_mount: [{UspAvaliaWeb.UserAuth, :mount_current_scope}] do
        live "/", ProfessorLive.Index, :index
        live "/:id", ProfessorLive.Show, :show
      end
    end

    scope "/perfis" do
      live_session :profiles,
        on_mount: [{UspAvaliaWeb.UserAuth, :require_authenticated}] do
        live "/verificar", ProfileLive.VerificarForm, :new
        live "/api", ProfileLive.ApiForm, :new
      end
    end

    scope "/disciplinas" do
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

    scope "/admin" do
      live_session :admin,
        on_mount: [{UspAvaliaWeb.UserAuth, :require_admin}] do
        live "/avaliar-pedidos", AdminLive.AvaliarPedidos, :index
      end
    end

    scope "/users" do
      scope "/" do
        pipe_through [:require_authenticated_user]

        live_session :require_authenticated_user,
          on_mount: [{UspAvaliaWeb.UserAuth, :require_authenticated}] do
          live "/settings", UserLive.Settings, :edit
          live "/settings/confirm-email/:token", UserLive.Settings, :confirm_email
        end

        post "/update-password", UserSessionController, :update_password
      end

      scope "/" do
        live_session :current_user,
          on_mount: [{UspAvaliaWeb.UserAuth, :mount_current_scope}] do
          live "/register", UserLive.Registration, :new
          live "/log-in", UserLive.Login, :new
          live "/log-in/:token", UserLive.Confirmation, :new
        end

        post "/log-in", UserSessionController, :create
        delete "/log-out", UserSessionController, :delete
      end
    end
  end
end
