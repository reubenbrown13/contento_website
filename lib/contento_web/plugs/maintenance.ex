defmodule ContentoWeb.Plug.Maintenance do
  import Plug.Conn, only: [halt: 1]
  import Phoenix.Controller, only: [render: 3, put_layout: 2]
  import Contento.Guardian.Plug, only: [authenticated?: 1]

  alias ContentoWeb.WebsiteView

  def init(opts), do: opts

  def call(conn, _opts) do
    settings = conn.assigns[:settings]

    if settings.maintenance && !authenticated?(conn) do
      conn
      |> put_layout(false)
      |> render(WebsiteView, settings.theme.alias <> "/templates/maintenance.html")
      |> halt()
    else
      conn
    end
  end
end
