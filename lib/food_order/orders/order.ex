defmodule FoodOrder.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias FoodOrder.Accounts.User

  @status_values ~w/NOT_STARTED RECEIVED PREPARING DELIVERING DELIVERED/a
  @field ~w/status/a
  @required_field ~w/total_price total_quantity user_id address phone_number/a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    field :address, :string
    field :total_price, Money.Ecto.Amount.Type
    field :total_quantity, :integer
    field :phone_number, :string
    field :status, Ecto.Enum, values: @status_values, default: :NOT_STARTED

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @field ++ @required_field)
    |> validate_required(@required_field)
    |> validate_number(:total_quantity, greater_than: 0)
  end
end
