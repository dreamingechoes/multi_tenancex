defmodule MultiTenancexWeb.Admin.ProductController do
  use MultiTenancexWeb, :controller

  alias MultiTenancex.Companies
  alias MultiTenancex.Companies.Product

  def index(conn, _params) do
    products = Companies.list_products()
    render(conn, "index.html", products: products)
  end

  def new(conn, _params) do
    changeset = Companies.change_product(%Product{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"product" => product_params}) do
    case Companies.create_product(product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: admin_product_path(conn, :show, product))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Companies.get_product!(id)
    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = Companies.get_product!(id)
    changeset = Companies.change_product(product)
    render(conn, "edit.html", product: product, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Companies.get_product!(id)

    case Companies.update_product(product, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: admin_product_path(conn, :show, product))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", product: product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Companies.get_product!(id)
    {:ok, _product} = Companies.delete_product(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: admin_product_path(conn, :index))
  end
end
