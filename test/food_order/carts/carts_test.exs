defmodule FoodOrder.CartsTest do
  use FoodOrder.DataCase
  import FoodOrder.Carts
  import FoodOrder.ProductsFixtures

  describe "session" do
    test "create session" do
      assert create(444) == :ok
    end

    test "create session twice" do
      assert create(444) == :ok
      assert create(444) == :ok
    end
  end

  describe "add" do
    test "add product" do
      cart_id = Ecto.UUID.generate()
      create(cart_id)
      product = product_fixture()

      assert :ok == add(cart_id, product)
      assert 1 = get(cart_id).total_qty
    end

    test "add same product" do
      cart_id = Ecto.UUID.generate()
      create(cart_id)
      product = product_fixture()

      assert :ok == add(cart_id, product)
      assert 2 = inc(cart_id, product.id).total_qty
    end
  end

  describe "remove" do
    test "remove product" do
      cart_id = Ecto.UUID.generate()
      create(cart_id)
      product = product_fixture()

      assert :ok == add(cart_id, product)
      assert 1 = get(cart_id).total_qty

      assert :ok == remove(cart_id, product)
      assert 0 = get(cart_id).total_qty
    end

    test "remove same product" do
      cart_id = Ecto.UUID.generate()
      create(cart_id)
      product = product_fixture()

      assert :ok == add(cart_id, product)
      assert 2 = inc(cart_id, product.id).total_qty

      assert 1 = dec(cart_id, product.id).total_qty
    end
  end

  describe "delete" do
    test "delete cart" do
      cart_id = Ecto.UUID.generate()
      create(cart_id)

      assert :ok == delete(cart_id)
    end
  end
end
