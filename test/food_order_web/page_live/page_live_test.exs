defmodule FoodOrderWeb.PageLiveTest do
  use FoodOrderWeb.ConnCase
  import Phoenix.LiveViewTest
  import FoodOrder.ProductsFixtures

  test "load main hero html", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    hero_cta = "[data-role=hero-cta]"
    assert has_element?(view, "[data-role=hero]")
    assert has_element?(view, hero_cta)

    assert view |> element(hero_cta <> ">h6") |> render() =~ "Make your order"
    assert view |> element(hero_cta <> ">h1") |> render() =~ "Right Now!!!"
    assert view |> element(hero_cta <> ">button") |> render() =~ "Order Now"

    assert has_element?(view, "[data-role=hero-img]")
  end

  test "load load products html", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "[data-role=products-section]")
    assert has_element?(view, "[data-role=products-section]>h1", "All foods")
    assert has_element?(view, "[data-role=products-lists]")
  end

  test "load main items elements", %{conn: conn} do
    product = product_fixture()

    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "[data-role=item][data-id=#{product.id}]")
    assert has_element?(view, "[data-role=item][data-id=#{product.id}]>img")

    assert has_element?(
             view,
             "[data-role=item-details][data-id=#{product.id}]>h2",
             product.name
           )

    assert has_element?(
             view,
             "[data-role=item-details][data-id=#{product.id}]>span",
             Atom.to_string(product.size)
           )

    assert has_element?(
             view,
             "[data-role=item-details][data-id=#{product.id}]>div>span",
             Money.to_string(product.price)
           )

    assert view
           |> element("[data-role=item-details][data-id=#{product.id}]>div>button")
           |> render() =~ "Add"
  end
end
