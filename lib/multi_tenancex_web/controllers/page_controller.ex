defmodule MultiTenancexWeb.PageController do
  use MultiTenancexWeb, :controller

  alias MultiTenancex.Companies

  def index(conn, _params) do
    company =
      if Map.get(conn.assigns, :current_tenant) do
        Companies.get_company_by_slug!(
          Companies.get_company_slug(conn.assigns.current_tenant),
          conn.assigns.current_tenant
        )
      else
        nil
      end

    render(conn, "index.html", company: company)
  end
end
