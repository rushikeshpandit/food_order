defmodule FoodOrderWeb.Admin.PageLive.IndexTest do
  use FoodOrderWeb.ConnCase
  import FoodOrder.ProductsFixtures
  import Phoenix.LiveViewTest

  describe "index" do
    setup [:create_product, :register_and_log_in_admin_user]

    test "list products", %{conn: conn, product: product} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      assert has_element?(view, "header>div>h1", "List Products")
      product_id = "#products"
      assert has_element?(view, product_id)
      assert has_element?(view, product_id <> ">tr>td>div>span", product.name)
      assert has_element?(view, product_id <> ">tr>td>div>span", Money.to_string(product.price))
      assert has_element?(view, product_id <> ">tr>td>div>span", Atom.to_string(product.size))
    end

    test "add new product", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")
      assert view |> element("header>div>div>a", "New Product") |> render_click()
      assert_patch(view, ~p"/admin/products/new")

      assert view |> has_element?("#new-product-modal")

      assert view
             |> form("#products-form", product: %{})
             |> render_change() =~ "be blank"
    end

    test "delete product", %{conn: conn, product: _product} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      product_id = "#products"

      assert has_element?(view, product_id)

      view
      |> element(product_id <> ">tr>td>div>span>div>a", "Delete")
      |> render_click()

      assert has_element?(view, product_id)
    end

    test "updates product in listing", %{conn: conn, product: product} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      product_id = "#products"

      assert has_element?(view, product_id)

      view
      |> element(product_id <> ">tr>td>div>span>div>a", "Edit")
      |> render_click()

      assert_patch(view, ~p"/admin/products/#{product.id}/edit")

      {:ok, _, html} =
        view
        |> form("#products-form", product: %{name: "pumpkin name updated"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/products")

      assert html =~ "Product updated successfully"
      assert html =~ "pumpkin name updated"
    end

    test "updates product within modal", %{conn: conn, product: product} do
      {:ok, view, _html} = live(conn, ~p"/admin/products/#{product}")

      assert view |> element("a", "Edit") |> render_click() =~
               "Edit"

      assert_patch(view, ~p"/admin/products/#{product}/show/edit")

      assert view
             |> form("#products-form", product: %{description: nil})
             |> render_submit() =~ "be blank"

      {:ok, _, html} =
        view
        |> form("#products-form", product: %{description: "pumpkin updated"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/products/#{product}")

      assert html =~ "Product updated successfully"
      assert html =~ "pumpkin updated"
    end
  end

  describe "sort" do
    setup [:create_product, :register_and_log_in_admin_user]

    test "sort products", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      view |> element("th>a", "name") |> render_click()

      assert_patched(
        view,
        ~p"/admin/products?name=&sort_by=name&sort_order=asc&per_page=4&page=1&"
      )

      view |> element("th>a", "name") |> render_click()

      assert_patched(
        view,
        ~p"/admin/products?name=&sort_by=name&sort_order=desc&per_page=4&page=1&"
      )
    end
  end

  describe "upload images" do
    setup [:register_and_log_in_admin_user]

    test "cancel when upload images", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")
      assert view |> element("header>div>div>a", "New Product") |> render_click()

      assert_patch(view, ~p"/admin/products/new")

      assert view |> has_element?("#new-product-modal")

      upload =
        file_input(view, "#product-form", :image_url, [
          %{
            last_modified: 1_594_171_879_000,
            name: "myfile.jpeg",
            content: " ",
            type: "image/jpeg"
          }
        ])

      assert render_upload(upload, "myfile.jpeg", 100) =~ "100%"

      [upload | _] = upload.entries

      assert has_element?(view, "##{upload["ref"]}")

      ref = "[phx-click=cancel][phx-value-ref=#{upload["ref"]}]"
      assert view |> element(ref) |> render_click()
      refute has_element?(view, "##{upload["ref"]}")
    end
  end

  def create_product(_) do
    product = product_fixture()
    %{product: product}
  end
end
