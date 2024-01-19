defmodule FoodOrder.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @sizes_value ~w/SMALL MEDIUM LARGE/a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field :name, :string
    field :image_url, :string
    field :size, Ecto.Enum, values: @sizes_value, default: :SMALL
    field :description, :string
    field :price, Money.Ecto.Amount.Type

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :price, :size, :description, :image_url])
    |> validate_required([:name, :price, :size, :description])
  end
end
