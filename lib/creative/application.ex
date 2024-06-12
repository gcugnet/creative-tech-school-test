defmodule Creative.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CreativeWeb.Telemetry,
      # Start the Ecto repository
      Creative.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Creative.PubSub},
      # Start Finch
      {Finch, name: Creative.Finch},
      # Start the Endpoint (http/https)
      CreativeWeb.Endpoint
      # Start a worker by calling: Creative.Worker.start_link(arg)
      # {Creative.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Creative.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CreativeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
