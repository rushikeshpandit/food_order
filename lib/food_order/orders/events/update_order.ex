defmodule FoodOrder.Orders.Events.UpdateOrder do
  alias Phoenix.PubSub
  @pubsub FoodOrder.PubSub
  @admin_order_updated "admin_order_updated"
  @update_user_row "update_user_row"
  @update_order "update_order"

  def subscribe_admin_order_update, do: PubSub.subscribe(@pubsub, @admin_order_updated)

  def broadcast_admin_order_update({:ok, order} = result, old_status) do
    PubSub.broadcast(@pubsub, @admin_order_updated, {:order_updated, order, old_status})
    result
  end

  def broadcast_admin_order_update({:error, _} = err, _), do: err

  def subscribe_update_user_row(user_id),
    do: PubSub.subscribe(@pubsub, @update_user_row <> ":#{user_id}")

  def broadcast_update_user_row({:ok, order} = result) do
    PubSub.broadcast(
      @pubsub,
      @update_user_row <> ":#{order.user_id}",
      {:update_order_user_row, order}
    )

    result
  end

  def broadcast_update_order({:error, _} = err, _), do: err

  def subscribe_update_order(id),
    do: PubSub.subscribe(@pubsub, @update_order <> ":#{id}")

  def broadcast_update_order({:ok, order} = result) do
    PubSub.broadcast(
      @pubsub,
      @update_order <> ":#{order.id}",
      {:update_order, order}
    )

    result
  end

  def broadcast_update_order({:error, _} = err, _), do: err
end
