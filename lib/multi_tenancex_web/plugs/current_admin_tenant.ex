defmodule MultiTenancexWeb.Plug.CurrentAdminTenant do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    current_admin_tenant =
      case conn |> Guardian.Plug.claims do
        {:ok, %{"current_admin_tenant" => tenant}} -> tenant
        _ -> nil
      end

    assign(conn, :current_admin_tenant, current_admin_tenant)
  end
end
