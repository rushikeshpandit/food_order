defmodule FoodOrderWeb.Client do
  def all do
    [
      %{id: Ecto.UUID.generate(), name: "Rushi", value: 0},
      %{id: Ecto.UUID.generate(), name: "Renuka", value: 0},
      %{id: Ecto.UUID.generate(), name: "Varenya", value: 0}
    ]
  end
end
