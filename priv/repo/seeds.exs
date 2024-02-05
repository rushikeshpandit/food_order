alias FoodOrder.Accounts
alias FoodOrder.Products

Accounts.register_user(%{
  email: "admin@rpandit.com",
  password: "Admin@rp.in12",
  role: "ADMIN"
})

Accounts.register_user(%{
  email: "user@rpandit.com",
  password: "User@rp.in12",
  role: "USER"
})

for index <- 0..100,
    do:
      Products.create_product(%{
        description: "bla bla",
        name: "Pizza #{index}",
        price: :rand.uniform(10_000),
        size: Enum.random(["SMALL", "MEDIUM", "LARGE"]),
        image_url: "product_#{1..4 |> Enum.random()}.jpg"
      })
