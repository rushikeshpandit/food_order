defmodule FoodOrderWeb.PageLive do
  use FoodOrderWeb, :live_view

  def mount(params, _session, socket) do
    IO.inspect("mount #1")
    %{"name" => name} = params
    {:ok, assign(socket, name: name)}
  end

  def handle_params(params, uri, socket) do
    IO.inspect("handle_params #2")
    IO.inspect(params, label: "Params")
    IO.inspect(uri, label: "uri")
    IO.inspect(socket, label: "socket")
    {:noreply, socket}
  end

  def render(assigns) do
    IO.inspect("render #3")
    ~H"""
    Hi <%= @name %>
    <%= self() |> :erlang.pid_to_list() %>
    """
  end
end
