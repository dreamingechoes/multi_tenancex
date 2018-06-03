defmodule MultiTenancex.Companies do
  @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false

  alias MultiTenancex.Companies.Company
  alias MultiTenancex.Companies.Product
  alias MultiTenancex.Repo
  alias MultiTenancex.TenantActions

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies(tenant)
      [%Company{}, ...]

  """
  def list_companies(tenant) do
    Repo.all(Company, prefix: tenant)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123, tenant)
      %Company{}

      iex> get_company!(456, tenant)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id, tenant), do: Repo.get!(Company, id, prefix: tenant)

  @doc """
  Gets a single company by slug.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(slug, tenant)
      %Company{}

      iex> get_company!(slug, tenant)
      ** (Ecto.NoResultsError)

  """
  def get_company_by_slug!(slug, tenant) do
    query =
      from(company in Company, where: company.slug == ^slug, preload: :products)

    Repo.one!(query, prefix: tenant)
  end

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    changeset = Company.changeset(%Company{}, attrs)

    if changeset.valid? do
      tenant = Ecto.Changeset.get_field(changeset, :slug)

      Repo.transaction(fn ->
        TenantActions.new_tenant(Repo, tenant)

        Repo.insert!(changeset, prefix: TenantActions.build_prefix(tenant))
      end)
    else
      {:error, changeset}
    end
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value}, tenant)
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value}, tenant)
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs, tenant) do
    company
    |> Company.changeset(attrs)
    |> Repo.update(prefix: tenant)
  end

  @doc """
  Deletes a Company.

  ## Examples

      iex> delete_company(company, tenant)
      {:ok, %Company{}}

      iex> delete_company(company, tenant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company, tenant) do
    Repo.transaction(fn ->
      Repo.delete(company, prefix: tenant)

      # We have to delete company tenat
      TenantActions.drop_schema(Repo, tenant)
    end)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{source: %Company{}}

  """
  def change_company(%Company{} = company) do
    Company.changeset(company, %{})
  end

  @doc """
  Returns the slug for a company from a tenant id.

  ## Examples

      iex> get_company_slug(tenant)
      "company_name"

  """
  def get_company_slug(tenant) do
    tenant
    |> String.split("_")
    |> List.delete_at(0)
    |> Enum.join("_")
  end

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products(tenant)
      [%Product{}, ...]

  """
  def list_products(tenant) do
    Repo.all(Product, prefix: tenant)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123, tenant)
      %Product{}

      iex> get_product!(456, tenant)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id, tenant), do: Repo.get!(Product, id, prefix: tenant)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value}, tenant)
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value}, tenant)
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}, tenant) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert(prefix: tenant)
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value}, tenant)
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value}, tenant)
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs, tenant) do
    product
    |> Product.changeset(attrs)
    |> Repo.update(prefix: tenant)
  end

  @doc """
  Deletes a Product.

  ## Examples

      iex> delete_product(product, tenant)
      {:ok, %Product{}}

      iex> delete_product(product, tenant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product, tenant) do
    Repo.delete(product, prefix: tenant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{source: %Product{}}

  """
  def change_product(%Product{} = product) do
    Product.changeset(product, %{})
  end
end
