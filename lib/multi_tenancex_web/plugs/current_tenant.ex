defmodule MultiTenancexWeb.Plug.CurrentTenant do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    current_admin_tenant =
      case conn |> Guardian.Plug.claims do
        {:ok, %{"current_tenant" => tenant}} -> tenant
        _ -> nil
      end

    assign(conn, :current_tenant, current_admin_tenant)
  end
end
