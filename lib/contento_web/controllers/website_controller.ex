defmodule ContentoWeb.WebsiteController do
  use ContentoWeb, :controller

  alias Contento.Content

  action_fallback ContentoWeb.FallbackController

  def index(conn, _params) do
    posts = Content.list_posts(published: true)
    render(conn, template(conn, "index.html"), posts: posts)
  end

  def page_or_post(conn, %{"slug" => slug} = _params) do
    cond do
      page = Content.get_page(slug: slug) ->
        render(conn, template(conn, "page.html"), page: page)
      post = Content.get_post(slug: slug) ->
        render(conn, template(conn, "post.html"), post: post)
      true ->
        {:error, :website_not_found}
    end
  end

  defp template(conn, template) do
    conn.assigns[:settings].theme.alias <> "/templates/" <> template
  end
end
