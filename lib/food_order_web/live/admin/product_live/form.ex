defmodule FoodOrderWeb.Admin.ProductLive.Form do
  alias FoodOrder.Products
  use FoodOrderWeb, :live_component

  @upload_options [accept: ~w/.png .jpeg .jpg/, max_entries: 1]

  def update(%{product: product} = assigns, socket) do
    changeset = Products.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(form: to_form(changeset))
     |> allow_upload(:image_url, @upload_options)}
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
    product_params = build_image_url(socket, product_params)
    save(socket, socket.assigns.action, product_params)
  end

  defp save(socket, :new, product_params) do
    perform(socket, Products.create_product(product_params), "Product created successfully")
  end

  defp save(socket, :edit, product_params) do
    perform(
      socket,
      Products.update_product(socket.assigns.product, product_params),
      "Product updated successfully"
    )
  end

  defp perform(socket, function_result, message) do
    case function_result do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, message)
          |> push_navigate(to: socket.assigns.navigate)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image_url, ref)}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  defp get_file_name(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    "#{entry.uuid}.#{ext}"
  end

  defp build_image_url(socket, product_params) do
    [image_url | _] =
      consume_uploaded_entries(socket, :image_url, fn %{path: path}, entry ->
        file_name = get_file_name(entry)
        dest = Path.join("priv/static/uploads", file_name)
        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{file_name}"}
      end)

    Map.put(product_params, "image_url", image_url)
  end
end
