defmodule FoodOrder.Orders.AllStatusOrdersTest do
  use FoodOrder.DataCase

  alias FoodOrder.Orders.AllStatusOrders

  describe "all status order" do
    test "get all status order" do
      assert %AllStatusOrders{
               all: 1,
               delivered: 0,
               delivering: 0,
               not_started: 1,
               preparing: 0,
               received: 0
             } == AllStatusOrders.execute()
    end
  end
end
