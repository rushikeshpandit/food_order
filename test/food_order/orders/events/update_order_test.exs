defmodule FoodOrder.Orders.Events.UpdateOrderTest do
  use FoodOrder.DataCase
  alias FoodOrder.Orders.Events.UpdateOrder

  test "subscribe_update_admin_order" do
    UpdateOrder.subscribe_admin_order_update()
    assert {:messages, []} == Process.info(self(), :messages)

    UpdateOrder.broadcast_admin_order_update({:ok, %{status: :PREPARING}}, :RECEIVED)

    assert {:messages, [{:order_updated, %{status: :PREPARING}, :RECEIVED}]} ==
             Process.info(self(), :messages)
  end

  test "subscribe_update_user_row" do
    user_id = "123"
    UpdateOrder.subscribe_update_user_row(user_id)
    assert {:messages, []} == Process.info(self(), :messages)

    UpdateOrder.broadcast_update_user_row({:ok, %{status: :PREPARING, user_id: user_id}})

    assert {:messages, [{:update_order_user_row, %{status: :PREPARING, user_id: user_id}}]} ==
             Process.info(self(), :messages)
  end

  test "subscribe_update_order" do
    id = "123"
    UpdateOrder.subscribe_update_order(id)
    assert {:messages, []} == Process.info(self(), :messages)

    UpdateOrder.broadcast_update_order({:ok, %{status: :PREPARING, id: id}})

    assert {:messages, [{:update_order, %{status: :PREPARING, id: id}}]} ==
             Process.info(self(), :messages)
  end
end
