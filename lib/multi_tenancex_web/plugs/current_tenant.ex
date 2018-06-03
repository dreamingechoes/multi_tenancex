defmodule MultiTenancexWeb.Plug.CurrentTenant do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case Guardian.Plug.current_claims(conn) do
      %{"current_tenant" => current_tenant} ->
        assign(conn, :current_tenant, current_tenant)

      _ ->
        conn
    end
  end
end
