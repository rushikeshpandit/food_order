defmodule FoodOrderWeb.Admin.OrderLive.Index.LayerTest do
  use FoodOrderWeb.ConnCase
  alias FoodOrder.Orders
  import FoodOrder.OrdersFixtures
  import FoodOrder.ProductsFixtures
  import Phoenix.LiveViewTest

  describe "layer test" do
    setup [:register_and_log_in_admin_user]

    test "render main elements", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/admin/orders")
      assert has_element?(view, "h3", "Not started")
    end

    test "change card to another layer", %{conn: conn, user: user} do
      product = product_fixture()
      order = order_fixtures(product, user)

      {:ok, view, _html} = live(conn, ~p"/admin/orders")
      assert has_element?(view, "#NOT_STARTED>##{order.id}")
      refute has_element?(view, "#PREPARING>##{order.id}")

      view
      |> element("#NOT_STARTED")
      |> render_hook("dropped", %{
        "new_status" => "PREPARING",
        "old_status" => "NOT_STARTED",
        "order_id" => order.id
      })

      refute has_element?(view, "#NOT_STARTED>##{order.id}")
      assert has_element?(view, "#PREPARING>##{order.id}")
    end

    test "change card to the same layer", %{conn: conn, user: user} do
      product = product_fixture()
      order = order_fixtures(product, user)

      {:ok, view, _html} = live(conn, ~p"/admin/orders")
      assert has_element?(view, "#NOT_STARTED>##{order.id}")

      view
      |> element("#NOT_STARTED")
      |> render_hook("dropped", %{
        "new_status" => "NOT_STARTED",
        "old_status" => "NOT_STARTED",
        "order_id" => order.id
      })

      assert has_element?(view, "#NOT_STARTED>##{order.id}")
    end

    test "send to another layer using handle_info", %{conn: conn, user: user} do
      product = product_fixture()
      order = order_fixtures(product, user)

      {:ok, view, _html} = live(conn, ~p"/admin/orders")
      assert has_element?(view, "#NOT_STARTED>##{order.id}")
      refute has_element?(view, "#RECEIVED>##{order.id}")

      Orders.update_order_status(order.id, "NOT_STARTED", "RECEIVED")

      refute has_element?(view, "#NOT_STARTED>##{order.id}")
      assert has_element?(view, "#RECEIVED>##{order.id}")
    end

    # test "send to another layer using handle_info using pid", %{conn: conn, user: user} do
    #   product = product_fixture()
    #   order = order_fixtures(product, user)

    #   {:ok, view, _html} = live(conn, ~p"/admin/orders")
    #   assert has_element?(view, "#NOT_STARTED>##{order.id}")
    #   refute has_element?(view, "#RECEIVED>##{order.id}")

    #   order = order |> Map.update(status: :RECEIVED)
    #   send(view.pid, {:order_updated, order, :NOT_STARTED})

    #   refute has_element?(view, "#NOT_STARTED>##{order.id}")
    #   assert has_element?(view, "#RECEIVED>##{order.id}")
    # end
  end
end
