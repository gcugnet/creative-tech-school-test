defmodule CreativeWeb.PageControllerTest do
  use CreativeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")

    assert html_response(conn, 302) =~
             "You are being <a href=\"/contacts\">redirected</a>."
  end
end
