defmodule MultiTenancex.CompaniesTest do
  use MultiTenancex.DataCase

  alias MultiTenancex.Companies

  describe "companies" do
    alias MultiTenancex.Companies.Company

    @valid_attrs %{description: "some description", image: "some image", name: "some name", slug: "some slug"}
    @update_attrs %{description: "some updated description", image: "some updated image", name: "some updated name", slug: "some updated slug"}
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
      assert Companies.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} = Companies.create_company(@valid_attrs)
      assert company.description == "some description"
      assert company.image == "some image"
      assert company.name == "some name"
      assert company.slug == "some slug"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      assert {:ok, company} = Companies.update_company(company, @update_attrs)
      assert %Company{} = company
      assert company.description == "some updated description"
      assert company.image == "some updated image"
      assert company.name == "some updated name"
      assert company.slug == "some updated slug"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end

  describe "products" do
    alias MultiTenancex.Companies.Product

    @valid_attrs %{description: "some description", image: "some image", name: "some name", price: 120.5, units: 42}
    @update_attrs %{description: "some updated description", image: "some updated image", name: "some updated name", price: 456.7, units: 43}
    @invalid_attrs %{description: nil, image: nil, name: nil, price: nil, units: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Companies.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Companies.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Companies.create_product(@valid_attrs)
      assert product.description == "some description"
      assert product.image == "some image"
      assert product.name == "some name"
      assert product.price == 120.5
      assert product.units == 42
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, product} = Companies.update_product(product, @update_attrs)
      assert %Product{} = product
      assert product.description == "some updated description"
      assert product.image == "some updated image"
      assert product.name == "some updated name"
      assert product.price == 456.7
      assert product.units == 43
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_product(product, @invalid_attrs)
      assert product == Companies.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Companies.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Companies.change_product(product)
    end
  end
end
