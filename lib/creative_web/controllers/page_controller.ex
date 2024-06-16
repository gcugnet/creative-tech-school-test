defmodule CreativeWeb.PageController do
  use CreativeWeb, :controller

  def home(conn, _params) do
    # We directly redirect the connexion to our contacts page.
    redirect(conn, to: ~p"/contacts")
  end
end
