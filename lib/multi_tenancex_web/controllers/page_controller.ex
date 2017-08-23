defmodule MultiTenancexWeb.PageController do
  use MultiTenancexWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
