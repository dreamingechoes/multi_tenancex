defmodule MultiTenancex.Companies.Company do
  alias MultiTenancex.Companies.Company
  import Ecto.Changeset
  use Ecto.Schema

  @type t :: %__MODULE__{}

  schema "companies" do
    field :description, :string
    field :image,       :string
    field :name,        :string
    field :slug,        :string

    timestamps()

    # Relations
    has_many :products, MultiTenancex.Companies.Product
  end

  @doc false
  def changeset(%Company{} = company, attrs) do
    company
    |> cast(attrs, [:name, :description, :image, :slug])
    |> validate_required([:name, :description, :image, :slug])
    |> unique_constraint(:name)
  end
end
