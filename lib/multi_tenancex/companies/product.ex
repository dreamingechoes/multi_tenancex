defmodule MultiTenancex.Companies.Product do
  alias MultiTenancex.Companies.Product
  import Ecto.Changeset
  use Ecto.Schema

  @type t :: %__MODULE__{}

  schema "products" do
    field(:description, :string)
    field(:image, :string)
    field(:name, :string)
    field(:price, :float)
    field(:units, :integer)

    timestamps()

    # Relations
    belongs_to(:company, MultiTenancex.Companies.Company)
  end

  @doc false
  def changeset(%Product{} = product, attrs) do
    product
    |> cast(attrs, [:name, :description, :image, :price, :units])
    |> validate_required([
      :name,
      :description,
      :image,
      :price,
      :units
    ])
    |> assoc_constraint(:company)
  end
end
