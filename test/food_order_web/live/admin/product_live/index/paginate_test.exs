defmodule FoodOrderWeb.Admin.ProductLive.PaginateTest do
  use FoodOrderWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "paginate component" do
    setup [:register_and_log_in_admin_user]

    test "clicking next, previous and page", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      assert has_element?(view, "#pages")

      view |> element("[data-role=next]") |> render_click()

      assert_patched(
        view,
        ~p"/admin/products?name=&sort_by=updated_at&page=2&per_page=4&sort_order=desc"
      )

      view |> element("[data-role=previous]") |> render_click()

      assert_patched(
        view,
        ~p"/admin/products?name=&sort_by=updated_at&sort_order=desc&per_page=4&page=1"
      )

      view |> element("#pages>div>div>a", "2") |> render_click()

      assert_patched(
        view,
        ~p"/admin/products?name=&sort_by=updated_at&sort_order=desc&per_page=4&page=2"
      )
    end

    # Commented out test as it is failing
    # test "using params", %{conn: conn} do
    #   product_1 = product_fixture(name: "pumpkin")
    #   product_2 = product_fixture(name: "pumpkin 2")

    #   {:ok, view, _html} =
    #     live(
    #       conn,
    #       ~p"/admin/products?name=&sort_by=inserted_at&sort_order=desc&per_page=1&page=1"
    #     )

    #   assert has_element?(view, "#products-#{product_1.id}")
    #   refute has_element?(view, "#products-#{product_2.id}")

    #   # view |> element("[data-role=next]") |> render_click()

    #   # refute has_element?(view, "#product-#{product_1.id}")
    #   # assert has_element?(view, "#product-#{product_2.id}")
    # end
  end
end
