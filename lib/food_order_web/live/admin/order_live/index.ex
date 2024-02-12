defmodule FoodOrderWeb.Admin.OrderLive.Index do
  use FoodOrderWeb, :live_view
  alias __MODULE__.Layer
  alias __MODULE__.SideMenu
  alias FoodOrder.Orders

  def mount(_, _, socket) do
    if connected?(socket) do
      Orders.subscribe_admin_order_update()
      Orders.subscribe_to_receive_new_orders()
    end

    {:ok, socket}
  end

  def handle_info({:order_updated, %{status: new_status}, old_status}, socket) do
    send_update(Layer, id: old_status)
    send_update(Layer, id: Atom.to_string(new_status))
    send_update(SideMenu, id: "side-menu")
    {:noreply, socket}
  end

  def handle_info({:new_order, %{status: status}}, socket) do
    send_update(Layer, id: Atom.to_string(status))
    send_update(SideMenu, id: "side-menu")
    {:noreply, socket}
  end
end
