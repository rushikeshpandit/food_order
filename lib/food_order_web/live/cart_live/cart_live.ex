defmodule FoodOrderWeb.CartLive do
  use FoodOrderWeb, :live_view
  alias FoodOrderWeb.CartLive.Details

  def mount(_, _, socket) do
    {:ok, assign(socket, total_qty: Enum.random([0, 10]))}
  end

  defp empty_cart(assigns) do
    ~H"""
    <div class="py-16 container mx-auto text-center">
      <h1 class="text-3xl font-bold mb-2">Your cart is Empty!</h1>
      <p class="text-neutral-500 text-lg mb-12">
        You probably haven't ordered food yet. <br /> To order good food, go to main page.
      </p>
      <.icon name="hero-shopping-bag-solid" class="h-20 w-20 text-orange-500" /> <br />
      <a
        href={~p"/"}
        class=" bg-orange-500 inline-block px-6 py-2 rounded-full text-white font-bold mt-12"
      >
        Go Back
      </a>
    </div>
    """
  end
end
