defmodule FoodOrderWeb.Customer.OrderLive.Status do
  import Phoenix.Naming, only: [humanize: 1]
  use FoodOrderWeb, :live_view
  alias FoodOrder.Orders

  def handle_params(%{"id" => id}, _uri, socket) do
    if connected?(socket) do
      Orders.subscribe_update_order(id)
    end

    current_user = socket.assigns.current_user
    order = Orders.get_order_by_id_and_customer_id(id, current_user.id)
    status_list = Orders.get_status_list()
    {:noreply, assign(socket, order: order, status_list: status_list)}
  end

  def handle_info({:update_order, order}, socket) do
    {:noreply, assign(socket, order: order)}
  end

  def get_icon(%{status: :NOT_STARTED} = assigns) do
    ~H"""
    <.icon name="hero-face-frown" class="h-10 w-10 text-orange-500 stroke-current" />
    """
  end

  def get_icon(%{status: :RECEIVED} = assigns) do
    ~H"""
    <.icon name="hero-receipt-percent" class="h-10 w-10 text-orange-500 stroke-current" />
    """
  end

  def get_icon(%{status: :PREPARING} = assigns) do
    ~H"""
    <.icon name="hero-building-storefront" class="h-10 w-10 text-orange-500 stroke-current" />
    """
  end

  def get_icon(%{status: :DELIVERING} = assigns) do
    ~H"""
    <.icon name="hero-truck" class="h-10 w-10 text-orange-500 stroke-current" />
    """
  end

  def get_icon(%{status: :DELIVERED} = assigns) do
    ~H"""
    <.icon name="hero-face-smile" class="h-10 w-10 text-orange-500 stroke-current" />
    """
  end
end
