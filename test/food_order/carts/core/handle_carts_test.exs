defmodule FoodOrder.Carts.Core.HandleCartsTest do
  use FoodOrder.DataCase

  import FoodOrder.ProductsFixtures
  import FoodOrder.Carts.Core.HandleCarts

  alias FoodOrder.Carts.Data.Cart

  @start_cart %Cart{
    id: 444_444,
    items: [],
    total_price: %Money{amount: 0, currency: :USD},
    total_qty: 0
  }

  describe "session" do
    test "create new cart" do
      assert @start_cart == create(444_444)
    end
  end

  describe "add" do
    test "add new item to cart" do
      product = product_fixture()

      cart = add(@start_cart, product)

      assert 1 == cart.total_qty
      assert [%{item: product, qty: 1}] == cart.items
      assert product.price == cart.total_price
    end

    test "add the same item twice" do
      product = product_fixture()

      cart = @start_cart |> add(product) |> add(product)

      assert 2 == cart.total_qty
      assert Money.add(product.price, product.price) == cart.total_price
      assert [%{item: product, qty: 2}] == cart.items
    end
  end

  describe "remove" do
    test "remove an item" do
      product = product_fixture()
      product_2 = product_fixture()

      cart =
        @start_cart
        |> add(product)
        |> add(product)
        |> add(product_2)

      assert 3 == cart.total_qty

      assert product.price
             |> Money.add(product.price)
             |> Money.add(product_2.price) == cart.total_price

      assert [%{item: product, qty: 2}, %{item: product_2, qty: 1}] == cart.items

      cart = remove(cart, product.id)

      assert 1 == cart.total_qty
      assert product_2.price == cart.total_price
      assert [%{item: product_2, qty: 1}] == cart.items
    end
  end

  describe "inc" do
    test "inc same element" do
      product = product_fixture()

      cart = @start_cart |> add(product) |> add(product) |> inc(product.id)

      assert 3 == cart.total_qty

      assert product.price
             |> Money.add(product.price)
             |> Money.add(product.price) == cart.total_price
    end
  end

  describe "dec" do
    test "dec same element" do
      product = product_fixture()

      cart =
        @start_cart
        |> add(product)
        |> add(product)
        |> dec(product.id)

      assert 1 == cart.total_qty

      assert product.price
             |> Money.add(product.price)
             |> Money.subtract(product.price) == cart.total_price
    end

    test "dec until remove the product" do
      product = product_fixture()

      cart =
        @start_cart
        |> add(product)
        |> add(product)
        |> dec(product.id)
        |> dec(product.id)

      assert 0 == cart.total_qty
      assert [] == cart.items
      assert Money.new(0) == cart.total_price
    end
  end
end
