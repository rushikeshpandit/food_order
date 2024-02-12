defmodule FoodOrderWeb.Admin.OrderLive.Index.Layer do
  use FoodOrderWeb, :live_component
  alias __MODULE__.Card
  alias FoodOrder.Orders
  import Phoenix.Naming, only: [humanize: 1]

  def update(assigns, socket) do
    orders = Orders.list_orders_by_status(assigns.id)

    {:ok, socket |> assign(assigns) |> assign(cards: orders)}
  end

  def handle_event(
        "dropped",
        %{
          "new_status" => new_status,
          "old_status" => old_status
        },
        socket
      )
      when new_status == old_status do
    {:noreply, socket}
  end

  def handle_event("dropped", params, socket) do
    %{
      "new_status" => new_status,
      "old_status" => old_status,
      "order_id" => order_id
    } = params

    Orders.update_order_status(order_id, old_status, new_status)
    {:noreply, socket}
  end
end
