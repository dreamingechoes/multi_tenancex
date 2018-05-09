defmodule MultiTenancexWeb.Admin.DashboardController do
  use MultiTenancexWeb, :controller

  alias MultiTenancex.Accounts.Administrator
  alias MultiTenancex.Companies.Company
  alias MultiTenancex.Companies.Product
  alias MultiTenancex.Repo

  def index(conn, _params) do
    with companies <- Repo.aggregate(Company, :count, :id),
         administrators <- Repo.aggregate(Administrator, :count, :id),
         products <- Repo.aggregate(Product, :count, :id) do
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
    with company_name <- generate_name(params["company"]) do
      {:ok, claims} = Guardian.Plug.claims(conn)

      claims =
        claims
        |> Map.put("current_admin_tenant", company_name)

      conn
      |> Guardian.Plug.sign_in(
        %{administrator: current_admin(conn), company: company_name},
        :access,
        claims
      )
      |> put_flash(:info, gettext("You have successfuly switched tenant."))
      |> redirect(to: admin_dashboard_path(conn, :index))
    end
  end

  defp generate_name(name) do
    name
    |> String.split("_")
    |> List.delete_at(0)
    |> Enum.join("_")
  end
end
