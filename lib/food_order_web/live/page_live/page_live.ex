defmodule FoodOrderWeb.PageLive do
  use FoodOrderWeb, :live_view
  alias FoodOrderWeb.Client, as: CL
  alias FoodOrderWeb.PageLive.Client

  def mount(_params, _session, socket) do
    clients = CL.all()

    {:ok, assign(socket, clients: clients)}
  end

  def handle_info({:change_name, id, name}, socket) do
    send_update(Client, id: id, name: name)
    {:noreply, socket}
  end
end
