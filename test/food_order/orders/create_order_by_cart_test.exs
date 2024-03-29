defmodule FoodOrder.Orders.CreateOrderByCartTest do
  use FoodOrder.DataCase
  alias FoodOrder.Carts
  alias FoodOrder.Orders.CreateOrderByCart

  import FoodOrder.AccountsFixtures
  import FoodOrder.ProductsFixtures

  describe "create_order/1" do
    test "create order with success" do
      product = product_fixture()
      user = user_fixture()

      Carts.create(user.id)
      Carts.add(user.id, product)

      assert 1 == Carts.get(user.id).total_qty

      payload = %{
        "address" => "123",
        "current_user" => user.id,
        "phone_number" => "1234"
      }

      {:ok, result} = CreateOrderByCart.execute(payload)

      assert 1 == result.total_quantity
    end

    test "error creating order" do
      user = user_fixture()
      Carts.create(user.id)

      payload = %{
        "address" => "123",
        "current_user" => user.id,
        "phone_number" => "123"
      }

      {:error, changeset} = CreateOrderByCart.execute(payload)

      assert "must be greater than 0" in errors_on(changeset).total_quantity
    end
  end
end
