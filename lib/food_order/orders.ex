defmodule FoodOrder.Orders do
  alias __MODULE__.AllStatusOrders
  alias __MODULE__.Events.NewOrder

  defdelegate subscribe_to_receive_new_order, to: NewOrder, as: :subscribe

  defdelegate all_status_orders, to: AllStatusOrders, as: :execute
end
