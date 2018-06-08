defmodule MultiTenancex.CompaniesTest do
  use MultiTenancex.DataCase

  alias MultiTenancex.Companies

  describe "companies" do
    alias MultiTenancex.Companies.Company
    alias MultiTenancex.TenantActions

    @valid_attrs %{
      description: "some description",
      image: "some image",
      name: "some company name",
      slug: "some_company_name"
    }
    @update_attrs %{
      description: "some updated description",
      image: "some updated image",
      name: "some updated company name"
    }
    @invalid_attrs %{description: nil, image: nil, name: nil, slug: nil}

    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_company()

      company
    end

    test "list_companies/0 returns all companies" do
      company = company_fixture()

      assert Companies.list_companies(TenantActions.build_prefix(company.slug)) ==
               [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()

      assert Companies.get_company!(
               company.id,
               TenantActions.build_prefix(company.slug)
             ) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} =
               Companies.create_company(@valid_attrs)

      assert company.description == "some description"
      assert company.image == "some image"
      assert company.name == "some company name"
      assert company.slug == "some_company_name"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()

      assert {:ok, company} =
               Companies.update_company(
                 company,
                 @update_attrs,
                 TenantActions.build_prefix(company.slug)
               )

      assert %Company{} = company
      assert company.description == "some updated description"
      assert company.image == "some updated image"
      assert company.name == "some updated company name"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Companies.update_company(
                 company,
                 @invalid_attrs,
                 TenantActions.build_prefix(company.slug)
               )

      assert company ==
               Companies.get_company!(
                 company.id,
                 TenantActions.build_prefix(company.slug)
               )
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()

      assert {:ok, {:ok, %Postgrex.Result{}}} =
               Companies.delete_company(
                 company,
                 TenantActions.build_prefix(company.slug)
               )
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end

  describe "products" do
    alias MultiTenancex.Companies.Product

    @valid_attrs %{
      description: "some description",
      image: "some image",
      name: "some name",
      price: 120.5,
      units: 42,
      company_id: 1
    }
    @update_attrs %{
      description: "some updated description",
      image: "some updated image",
      name: "some updated name",
      price: 456.7,
      units: 43
    }
    @invalid_attrs %{
      description: nil,
      image: nil,
      name: nil,
      price: nil,
      units: nil
    }

    def product_fixture(tenant), do: product_fixture(@valid_attrs, tenant)

    def product_fixture(attrs, tenant) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_product(tenant)

      product
    end

    test "list_products/0 returns all products", %{tenant: tenant} do
      product = product_fixture(tenant)
      assert Companies.list_products(tenant) == [product]
    end

    test "get_product!/1 returns the product with given id", %{tenant: tenant} do
      product = product_fixture(tenant)
      assert Companies.get_product!(product.id, tenant) == product
    end

    test "create_product/1 with valid data creates a product", %{tenant: tenant} do
      assert {:ok, %Product{} = product} =
               Companies.create_product(@valid_attrs, tenant)

      assert product.description == "some description"
      assert product.image == "some image"
      assert product.name == "some name"
      assert product.price == 120.5
      assert product.units == 42
    end

    test "create_product/1 with invalid data returns error changeset", %{
      tenant: tenant
    } do
      assert {:error, %Ecto.Changeset{}} =
               Companies.create_product(@invalid_attrs, tenant)
    end

    test "update_product/2 with valid data updates the product", %{
      tenant: tenant
    } do
      product = product_fixture(tenant)

      assert {:ok, product} =
               Companies.update_product(product, @update_attrs, tenant)

      assert %Product{} = product
      assert product.description == "some updated description"
      assert product.image == "some updated image"
      assert product.name == "some updated name"
      assert product.price == 456.7
      assert product.units == 43
    end

    test "update_product/2 with invalid data returns error changeset", %{
      tenant: tenant
    } do
      product = product_fixture(tenant)

      assert {:error, %Ecto.Changeset{}} =
               Companies.update_product(product, @invalid_attrs, tenant)

      assert product == Companies.get_product!(product.id, tenant)
    end

    test "delete_product/1 deletes the product", %{tenant: tenant} do
      product = product_fixture(tenant)
      assert {:ok, %Product{}} = Companies.delete_product(product, tenant)

      assert_raise Ecto.NoResultsError, fn ->
        Companies.get_product!(product.id, tenant)
      end
    end

    test "change_product/1 returns a product changeset", %{tenant: tenant} do
      product = product_fixture(tenant)
      assert %Ecto.Changeset{} = Companies.change_product(product)
    end
  end
end
