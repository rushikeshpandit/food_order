defmodule FoodOrderWeb.Customer.OrderLive.Index do
  import Phoenix.Naming, only: [humanize: 1]
  use FoodOrderWeb, :live_view
  alias FoodOrder.Orders

  def mount(_, _, socket) do
    current_user = socket.assigns.current_user
    if connected?(socket), do: Orders.subscribe_update_user_row(current_user.id)
    orders = Orders.list_orders_by_user_id(current_user.id)
    socket = socket |> assign(orders: orders)

    {:ok, socket}
  end
end
