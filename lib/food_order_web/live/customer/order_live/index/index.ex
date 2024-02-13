defmodule FoodOrderWeb.Customer.OrderLive.Index do
  alias __MODULE__.Row
  use FoodOrderWeb, :live_view
  alias FoodOrder.Orders

  def mount(_, _, socket) do
    current_user = socket.assigns.current_user
    if connected?(socket), do: Orders.subscribe_update_user_row(current_user.id)
    orders = Orders.list_orders_by_user_id(current_user.id)
    socket = socket |> assign(orders: orders)

    {:ok, socket}
  end

  def handle_info({:update_order_user_row, order}, socket) do
    send_update(Row, id: order.id, order_updated: order)
    {:noreply, socket}
  end
end
