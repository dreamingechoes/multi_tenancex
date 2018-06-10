defmodule MultiTenancexWeb.ProductControllerTest do
  use MultiTenancexWeb.ConnCase

  alias MultiTenancex.Companies

  @create_attrs %{
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

  def fixture(:product) do
    {:ok, product} = Companies.create_product(@create_attrs, "tenant_some_name")
    product
  end

  describe "index" do
    test "lists all products", %{conn: conn, administrator: administrator} do
      conn = get(log_in(administrator), admin_product_path(conn, :index))

      assert html_response(conn, 200) =~ "List of products"
    end
  end

  describe "new product" do
    test "renders form", %{conn: conn, administrator: administrator} do
      conn = get(log_in(administrator), admin_product_path(conn, :new))

      assert html_response(conn, 200) =~ "New product"
    end
  end

  describe "create product" do
    test "redirects to show when data is valid", %{
      conn: conn,
      administrator: administrator
    } do
      conn =
        post(
          log_in(administrator),
          admin_product_path(conn, :create),
          product: @create_attrs
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == admin_product_path(conn, :show, id)

      conn = get(log_in(administrator), admin_product_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show product"
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      administrator: administrator
    } do
      conn =
        post(
          log_in(administrator),
          admin_product_path(conn, :create),
          product: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "New product"
    end
  end

  describe "edit product" do
    setup [:create_product]

    test "renders form for editing chosen product", %{
      conn: conn,
      administrator: administrator,
      product: product
    } do
      conn =
        get(log_in(administrator), admin_product_path(conn, :edit, product))

      assert html_response(conn, 200) =~ "Edit product"
    end
  end

  describe "update product" do
    setup [:create_product]

    test "redirects when data is valid", %{
      conn: conn,
      administrator: administrator,
      product: product
    } do
      conn =
        put(
          log_in(administrator),
          admin_product_path(conn, :update, product),
          product: @update_attrs
        )

      assert redirected_to(conn) == admin_product_path(conn, :show, product)

      conn =
        get(log_in(administrator), admin_product_path(conn, :show, product))

      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      administrator: administrator,
      product: product
    } do
      conn =
        put(
          log_in(administrator),
          admin_product_path(conn, :update, product),
          product: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit product"
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{
      conn: conn,
      administrator: administrator,
      product: product
    } do
      conn =
        delete(
          log_in(administrator),
          admin_product_path(conn, :delete, product)
        )

      assert redirected_to(conn) == admin_product_path(conn, :index)
    end
  end

  defp create_product(_), do: {:ok, product: fixture(:product)}
end
