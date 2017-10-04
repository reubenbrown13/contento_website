defmodule ContentoWeb.ErrorView do
  use ContentoWeb, :view

  alias ContentoWeb.WebsiteView

  def render("404.html", assigns) do
    path = assigns[:conn].request_path

    if String.contains?(path, "/c") do
      render("not_found.html", %{})
    else
      theme_alias = assigns[:settings].theme.alias
      template = theme_alias <> "/templates/not_found.html"

      render(WebsiteView, template, %{})
    end
  end

  def render("500.html", _assigns) do
    render("internal_server_error.html", %{})
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
