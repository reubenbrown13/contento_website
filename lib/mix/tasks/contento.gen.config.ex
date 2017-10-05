defmodule Mix.Tasks.Contento.Gen.Config do
  use Mix.Task

  import Mix.Generator

  def run(args) do
    if "--prod" in args do
      assigns = [endpoint_secret_key: random_string(),
                 guardian_secret_key: random_string()]

      create_config("prod.secret.exs", prod_config_template(assigns))
    else
      assigns = [guardian_secret_key: random_string()]

      create_config("dev.secret.exs", dev_config_template(assigns))
    end

    Mix.Shell.IO.info("Don't forget you still may have to configure some options in the created file.")
  end

  defp create_config(file, template) do
    "config"
    |> Path.join(file)
    |> create_file(template)
  end

  defp random_string do
    :crypto.strong_rand_bytes(64) |> Base.encode64() |> binary_part(0, 64)
  end

  embed_template :dev_config, """
  use Mix.Config

  # Configure Database
  config :contento, Contento.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: "postgres",
    password: "postgres",
    database: "contento_dev",
    hostname: "localhost",
    pool_size: 10

  # Configure Guardian
  config :contento, Contento.Guardian,
    issuer: "contento_dev",
    secret_key: "<%= @guardian_secret_key %>"

  # Configure Bamboo
  config :contento, Contento.Mailer,
    adapter: Bamboo.LocalAdapter
  """

  embed_template :prod_config, """
  use Mix.Config

  # Configure Endpoint
  config :contento, ContentoWeb.Endpoint,
    secret_key_base: "<%= @endpoint_secret_key %>"

  # Configure Database
  config :contento, Contento.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: "postgres",
    password: "postgres",
    database: "contento_dev",
    hostname: "localhost",
    pool_size: 10

  # Configure Guardian
  config :contento, Contento.Guardian,
    issuer: "contento_dev",
    secret_key: "<%= @guardian_secret_key %>"

  # Configure Bamboo
  config :contento, Contento.Mailer,
    adapter: Bamboo.SMTPAdapter,
    server: {:system, "SMTP_SERVER"},
    port: {:system, "SMTP_PORT"},
    username: {:system, "SMTP_USERNAME"},
    password: {:system, "SMTP_PASSWORD"},
    tls: :if_available, # can be `:always` or `:never`
    allowed_tls_versions: [:"tlsv1", :"tlsv1.1", :"tlsv1.2"],
    ssl: false, # can be `true`
    retries: 1
  """
end
