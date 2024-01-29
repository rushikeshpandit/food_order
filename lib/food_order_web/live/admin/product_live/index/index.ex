defmodule FoodOrderWeb.Admin.ProductLive.Index do
  alias FoodOrder.Products.Product
  alias FoodOrderWeb.Admin.ProductLive.Form
  use FoodOrderWeb, :live_view
  alias FoodOrder.Products

  def mount(_, _, socket) do
    products = Products.list_products()
    {:ok, assign(socket, products: products)}
  end

  def handle_params(_params, _uri, socket) do
    live_action = socket.assigns.live_action
    {:noreply, apply_action(socket, live_action)}
  end

  defp apply_action(socket, :new) do
    socket |> assign(:page_title, "New Product") |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index) do
    socket |> assign(:page_title, "List Products")
  end

  defp apply_action(socket, :show) do
    socket |> assign(:page_title, "Show Products")
  end

  def handle_event("delete", %{"id" => id}, socket) do
    products = socket.assigns.products
    product = Enum.find(products, &(&1.id == id))
    Products.delete_product(product)

    delete_product = fn products -> Enum.filter(products, &(&1.id != id)) end

    {:noreply, update(socket, :products, delete_product)}
  end
end
