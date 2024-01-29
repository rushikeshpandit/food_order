defmodule FoodOrderWeb.ProductLiveTest do
  use FoodOrderWeb.ConnCase
  import FoodOrder.ProductsFixtures
  import Phoenix.LiveViewTest

  describe "index" do
    setup [:create_product]

    test "list products", %{conn: conn, product: _product} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      assert has_element?(view, "header>div>h1", "List Products")
      assert view |> element("#products") |> has_element?()
      # assert has_element?(view, product_id <> ">td>div>span", product.name)
      # assert has_element?(view, product_id <> ">td>div>span", Money.to_string(product.price))
      # assert has_element?(view, product_id <> ">td>div>span", Atom.to_string(product.size))
    end

    test "add new product", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")
      assert view |> element("header>div>a", "New Product") |> render_click()
      assert_patch(view, ~p"/admin/products/new")

      assert view |> has_element?("#new-product-modal")

      assert view
             |> form("#products-form", product: %{})
             |> render_change() =~ "be blank"
    end
  end

  def create_product(_) do
    product = product_fixture()
    %{product: product}
  end
end
