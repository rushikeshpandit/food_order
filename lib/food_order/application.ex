defmodule FoodOrder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias FoodOrder.Carts.Server.CartSession

  @impl true
  def start(_type, _args) do
    children = [
      FoodOrderWeb.Telemetry,
      FoodOrder.Repo,
      {DNSCluster, query: Application.get_env(:food_order, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FoodOrder.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FoodOrder.Finch},
      # Start a worker by calling: FoodOrder.Worker.start_link(arg)
      # {FoodOrder.Worker, arg},
      # Start to serve requests, typically the last entry
      FoodOrderWeb.Endpoint,
      CartSession
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FoodOrder.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FoodOrderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
