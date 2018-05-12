defmodule MultiTenancexWeb.Plug.CurrentTenant do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(
      conn,
      :current_tenant,
      MultiTenancex.Guardian.Plug.current_resource(conn)
    )
  end
end
