defmodule FoodOrderWeb.PageLive do
  alias FoodOrder.Products
  use FoodOrderWeb, :live_view
  alias FoodOrderWeb.PageLive.Item

  def mount(_, _, socket) do
    {:ok, assign(socket, products: Products.list_products())}
  end
end
