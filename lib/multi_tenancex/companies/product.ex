defmodule MultiTenancex.Companies.Product do
  use Ecto.Schema

  import Ecto.Changeset

  alias MultiTenancex.Companies.Product

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
    |> cast(attrs, [:name, :description, :image, :price, :units, :company_id])
    |> validate_required([
      :name,
      :description,
      :image,
      :price,
      :units,
      :company_id
    ])
    |> assoc_constraint(:company)
  end
end
