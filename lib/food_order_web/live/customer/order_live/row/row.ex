defmodule FoodOrderWeb.Customer.OrderLive.Index.Row do
  use FoodOrderWeb, :live_component
  import Phoenix.Naming, only: [humanize: 1]

  def update(%{order_updated: order}, socket) do
    {:ok, assign(socket, order: order)}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
