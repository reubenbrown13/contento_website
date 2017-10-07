alias Contento.Content

now = fn -> DateTime.utc_now() end

Content.create_page(%{
  "slug" => "about",

  "title" => "About",
  "content" => "Tell people something nice about you!",

  "published" => true,
  "published_at" => now.(),

  "author_id" => 1
})

Content.create_post(%{
  "slug" => "getting-started",

  "title" => "Getting started with Contento",
  "content" => "Hello!! This is your first post on Contento!",

  "published" => true,
  "published_at" => now.(),

  "author_id" => 1
})
