defmodule MultiTenancexWeb.Admin.DashboardController do
  use MultiTenancexWeb, :controller

  alias MultiTenancex.Accounts.Administrator
  alias MultiTenancex.Companies.Company
  alias MultiTenancex.Companies.Product
  alias MultiTenancex.Guardian.Plug
  alias MultiTenancex.Repo

  def index(conn, _params) do
    with tenant <- conn.assigns.current_tenant,
         administrators <- Repo.aggregate(Administrator, :count, :id),
         companies <- Repo.aggregate(Company, :count, :id, prefix: tenant),
         products <- Repo.aggregate(Product, :count, :id, prefix: tenant) do
      render(
        conn,
        "index.html",
        companies: companies,
        administrators: administrators,
        products: products
      )
    end
  end

  @doc """
  Switch between tenants for an administrator.
  """
  def switch_tenant(conn, %{"switch" => params}) do
    conn
    |> Plug.sign_in(conn.assigns.current_admin, %{
      current_tenant: params["tenant"]
    })
    |> put_flash(:info, gettext("You have successfuly switched tenant."))
    |> redirect(to: admin_dashboard_path(conn, :index))
  end
end
