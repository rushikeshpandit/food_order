defmodule FoodOrder.Orders do
  alias __MODULE__.Events.NewOrder
  alias __MODULE__.Events.UpdateOrder

  alias __MODULE__.{
    AllStatusOrders,
    CreateOrderByCart,
    GetOrderByIdAndCustomerId,
    ListOrdersByStatus,
    ListOrdersByUserId
  }

  defdelegate subscribe_to_receive_new_orders, to: NewOrder, as: :subscribe
  defdelegate all_status_orders, to: AllStatusOrders, as: :execute
  defdelegate create_order_by_cart(payload), to: CreateOrderByCart, as: :execute

  defdelegate get_order_by_id_and_customer_id(order_id, customer_id),
    to: GetOrderByIdAndCustomerId,
    as: :execute

  defdelegate list_orders_by_status(status), to: ListOrdersByStatus, as: :execute
  defdelegate list_orders_by_user_id(user_id), to: ListOrdersByUserId, as: :execute

  defdelegate subscribe_admin_order_update, to: UpdateOrder, as: :subscribe_admin_order_update

  defdelegate subscribe_update_user_row(user_id), to: UpdateOrder, as: :subscribe_update_user_row

  defdelegate subscribe_update_order(id), to: UpdateOrder, as: :subscribe_update_order
end
