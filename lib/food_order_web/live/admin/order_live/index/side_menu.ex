defmodule FoodOrderWeb.Admin.OrderLive.Index.SideMenu do
  use FoodOrderWeb, :live_component
  alias FoodOrder.Orders

  def update(assigns, socket) do
    status = Orders.all_status_orders() |> Map.from_struct()

    socket =
      socket |> assign(assigns) |> assign(status)

    {:ok, socket}
  end
end
