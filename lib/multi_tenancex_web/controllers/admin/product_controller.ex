defmodule MultiTenancexWeb.Admin.ProductController do
  use MultiTenancexWeb, :controller

  alias MultiTenancex.Companies
  alias MultiTenancex.Companies.Product

  def index(conn, _params) do
    products = Companies.list_products(conn.assigns.current_tenant)
    render(conn, "index.html", products: products)
  end

  def new(conn, _params) do
    changeset = Companies.change_product(%Product{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"product" => product_params}) do
    company =
      Companies.get_company_by_slug!(
        Companies.get_company_slug(conn.assigns.current_tenant),
        conn.assigns.current_tenant
      )

    product_params
    |> Map.put("company_id", company.id)
    |> Companies.create_product(conn.assigns.current_tenant)
    |> case do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: admin_product_path(conn, :show, product))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Companies.get_product!(id, conn.assigns.current_tenant)
    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = Companies.get_product!(id, conn.assigns.current_tenant)
    changeset = Companies.change_product(product)
    render(conn, "edit.html", product: product, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Companies.get_product!(id, conn.assigns.current_tenant)

    case Companies.update_product(
           product,
           product_params,
           conn.assigns.current_tenant
         ) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: admin_product_path(conn, :show, product))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", product: product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Companies.get_product!(id, conn.assigns.current_tenant)

    {:ok, _product} =
      Companies.delete_product(product, conn.assigns.current_tenant)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: admin_product_path(conn, :index))
  end
end
