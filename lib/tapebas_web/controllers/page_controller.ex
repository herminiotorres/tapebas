defmodule TapebasWeb.PageController do
  use TapebasWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
