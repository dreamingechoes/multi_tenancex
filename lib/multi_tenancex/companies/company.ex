defmodule MultiTenancex.Companies.Company do
  use Ecto.Schema

  import Ecto.Changeset

  alias MultiTenancex.Companies.Company

  schema "companies" do
    field(:description, :string)
    field(:image, :string)
    field(:name, :string)
    field(:slug, :string)

    timestamps()

    # Relations
    has_many(:products, MultiTenancex.Companies.Product)
  end

  @doc false
  def changeset(%Company{} = company, attrs) do
    company
    |> cast(attrs, [:name, :description, :image, :slug])
    |> validate_required([:name, :description, :image])
    |> unique_constraint(:name)
    |> generate_slug()
  end

  defp generate_slug(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{name: name}} ->
        slug =
          name
          |> String.downcase()
          |> String.replace(" ", "_")

        put_change(current_changeset, :slug, slug)

      _ ->
        current_changeset
    end
  end
end
