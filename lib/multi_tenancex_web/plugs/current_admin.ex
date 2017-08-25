defmodule MultiTenancexWeb.Plug.CurrentAdmin do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    with current_admin <- Guardian.Plug.current_resource(conn) do
      assign(conn, :current_admin, current_admin)
    end
  end

end
