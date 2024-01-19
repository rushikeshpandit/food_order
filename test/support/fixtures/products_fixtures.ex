defmodule FoodOrder.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodOrder.Products` context.
  """
  alias FoodOrder.Products

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        price: 42,
        image_url: "product_1.jpg"
      })
      |> Products.create_product()

    product
  end

  def get_all_products, do: Products.list_products()
end
