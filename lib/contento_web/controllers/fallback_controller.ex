defmodule ContentoWeb.FallbackController do
  use ContentoWeb, :controller

  def call(conn, {:error, :website_not_found}) do
    conn
    |> put_layout(false)
    |> render(ContentoWeb.ErrorView, "404.html")
  end
end
