defmodule FoodTruck.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FoodTruckWeb.Telemetry,
      # Start the Ecto repository
      FoodTruck.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: FoodTruck.PubSub},
      # Start Finch
      {Finch, name: FoodTruck.Finch},
      # Start the Endpoint (http/https)
      FoodTruckWeb.Endpoint
      # Start a worker by calling: FoodTruck.Worker.start_link(arg)
      # {FoodTruck.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FoodTruck.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FoodTruckWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
