defmodule MultiTenancexWeb.PageControllerTest do
  use MultiTenancexWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "MultiTenancex"
  end
end
