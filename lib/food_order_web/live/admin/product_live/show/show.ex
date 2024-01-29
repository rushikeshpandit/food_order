defmodule FoodOrderWeb.Admin.ProductLive.Show do
  alias FoodOrder.Products
  use FoodOrderWeb, :live_view

  def handle_params(%{"id" => id}, _uri, socket) do
    product = Products.get_product!(id)
    {:noreply, assign(socket, :product, product)}
  end
end
