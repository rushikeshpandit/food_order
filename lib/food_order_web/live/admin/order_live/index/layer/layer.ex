defmodule FoodOrderWeb.Admin.OrderLive.Index.Layer do
  use FoodOrderWeb, :live_component
  alias __MODULE__.Card
  import Phoenix.Naming, only: [humanize: 1]
  @status [:NOT_STARTED, :DELIVERED]

  def update(assigns, socket) do
    cards = [
      %{
        id: Ecto.UUID.generate(),
        status: @status |> Enum.shuffle() |> hd,
        user: %{email: "admin@rpandit.com"},
        total_price: Money.new(10_000),
        total_qty: 2,
        updated_at: NaiveDateTime.utc_now(),
        items: [
          %{
            id: Ecto.UUID.generate(),
            quantity: 10,
            product: %{name: "pumpkin", price: Money.new(200)}
          },
          %{
            id: Ecto.UUID.generate(),
            quantity: 10,
            product: %{name: "waffle", price: Money.new(500)}
          }
        ]
      }
    ]

    {:ok, socket |> assign(assigns) |> assign(cards: cards)}
  end
end
