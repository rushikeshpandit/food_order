alias FoodOrder.Products

for index <- 0..100,
    do:
      Products.create_product(%{
        description: "bla bla",
        name: "Pizza #{index}",
        price: :rand.uniform(10_000),
        size: Enum.random(["SMALL", "MEDIUM", "LARGE"]),
        image_url: "product_#{1..4 |> Enum.random()}.jpg"
      })
