defmodule MultiTenancexWeb.PageController do
  use MultiTenancexWeb, :controller

  alias MultiTenancex.Guardian

  def index(conn, _params), do: render(conn, "index.html")

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
