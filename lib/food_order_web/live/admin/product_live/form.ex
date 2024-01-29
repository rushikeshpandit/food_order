defmodule FoodOrderWeb.Admin.ProductLive.Form do
  alias FoodOrder.Products
  use FoodOrderWeb, :live_component

  def update(%{product: product} = assigns, socket) do
    changeset = Products.change_product(product)
    {:ok, socket |> assign(assigns) |> assign(form: to_form(changeset))}
  end

  def handle_event("validate", %{"product" => product_params}, socket) do
    form =
      socket.assigns.product
      |> Products.change_product(product_params)
      |> Map.put(:action, :insert)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    case Products.create_product(product_params) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Product created successfully")
          |> push_navigate(to: socket.assigns.navigate)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
