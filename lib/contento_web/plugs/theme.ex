defmodule ContentoWeb.Plug.Theme do
  import Phoenix.Controller

  alias ContentoWeb.WebsiteView

  def init(opts), do: opts

  def call(conn, _opts) do
    theme_alias = conn.assigns[:settings].theme.alias
    layout_template = theme_alias <> "/templates/layout.html"

    put_layout(conn, {WebsiteView, layout_template})
  end
end
