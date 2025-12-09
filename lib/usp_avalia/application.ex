defmodule UspAvalia.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UspAvaliaWeb.Telemetry,
      UspAvalia.Repo,
      {DNSCluster, query: Application.get_env(:usp_avalia, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: UspAvalia.PubSub},
      # Start a worker by calling: UspAvalia.Worker.start_link(arg)
      # {UspAvalia.Worker, arg},
      # Start to serve requests, typically the last entry
      UspAvaliaWeb.Endpoint,
      UspAvalia.ComandedApp,
      UspAvalia.ProfilesVerifications.ProfileVerificationHandler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UspAvalia.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UspAvaliaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
