defmodule Mix.Tasks.Contento.Setup do
  use Mix.Task

  import Mix.Ecto

  require Logger

  alias Contento.Settings
  alias Contento.Accounts
  alias Contento.Themes

  @default_settings %{
    "website_title" => "An Awesome Website",
    "website_description" => "Random Opinions and Ideas",
    "theme_id" => 1
  }

  @default_user %{
    "name" => "Default User",
    "handle" => "contento",
    "email" => "contento@example.org",
    "password" => "contento"
  }

  def run(args) do
    # welcome_message()

    # if installed?() do
    #   if "--force" in args do
    #     Mix.Task.run("ecto.drop")
    #   else
    #     raise_already_installed()
    #   end
    # end

    # Create database and run migrations
    # Mix.shell.cmd("mix ecto.create")
    # Mix.shell.cmd("mix ecto.migrate")
    #
    # # Load themes
    # Mix.Task.run("contento.load.themes")

    ensure_started(Contento.Repo, [])

    themes = Themes.list_themes()

    if length(themes) == 0 do
      raise_no_themes()
    end

    settings = if "--defaults" in args do
      @default_settings
    else
      Map.new()
      |> prompt(:website_title, @default_settings["website_title"])
      |> prompt(:website_description, @default_settings["website_description"])
      |> prompt_theme(:theme_id, themes)
    end

    Logger.info "Creating settings and default user..."

    with {:ok, _settings} <- Settings.create_settings(settings),
         {:ok, _user} <- Accounts.create_user(@default_user) do

      Logger.info """
      Done, Contento is ready to run!

      You may now run Contento with:

        mix phx.server

      Default user credentials:

        Email: #{@default_user["email"]}
        Password: #{@default_user["password"]}
      """
    end
  end

  defp prompt(settings, prop, default) do
    answer = "#{prop_to_name(prop)} (default: #{inspect default})"
    |> Mix.Shell.IO.prompt()
    |> String.replace("\n", "")

    answer = if answer != "", do: answer, else: default

    Map.put(settings, prop, answer)
  end

  defp prompt_theme(settings, prop, themes) do
    Mix.Shell.IO.info("Select a theme (type the ID):")

    for theme <- themes do
      Mix.Shell.IO.info("\t - #{theme.name}: #{theme.id}")
    end

    answer = Mix.Shell.IO.prompt(">")
    |> String.replace("\n", "")

    options = Enum.map(themes, fn theme -> Integer.to_string(theme.id) end)

    cond do
      answer == "" ->
        Map.put(settings, prop, Enum.at(themes, 0).id)
      !(answer in options) ->
        Mix.Shell.IO.info("#{answer} is not a valid option.")
        prompt_theme(settings, prop, themes)
      true ->
        Map.put(settings, prop, String.to_integer(answer))
    end
  end

  defp prop_to_name(prop) do
    prop
    |> Atom.to_string()
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  defp installed? do
    try do
      {:ok, pid, _} = ensure_started(Contento.Repo, [])

      settings = Settings.get_settings()

      Contento.Repo.stop(pid, 5000)

      if is_nil(settings) do
        false
      else
        true
      end
    rescue
      DBConnection.ConnectionError ->
        false
      Postgrex.Error ->
        false
    end
  end

  defp welcome_message do
    config_file = if Mix.env == :prod, do: Path.join("config", "prod.secret.exs"),
                          else: Path.join("config", "dev.secret.exs")

    Mix.Shell.IO.info """
    Hello!

    We're glad you've decided to install and use Contento!

    Follow the instructions to get a ready-to-use Contento installation in just
    a few minutes!

    NOTE: This installation utility expects that your #{config_file} exists and
    is correctly setup.

    You can generate a config file with:

      MIX_ENV=#{Mix.env} mix contento.gen.config
    """
  end

  defp raise_no_themes do
    Mix.raise """
    No themes registered in database. Please make sure to load all themes by running:

      mix contento.load.themes

    If this error persists, check if there is any theme in priv/themes directory.
    """
  end

  defp raise_already_installed do
    Mix.raise """
    Contento is already installed given the configuration provided. If you
    wish to overwrite the installation run:

      mix contento.install --force

    Note that this will entirely delete your current database.
    """
  end
end
