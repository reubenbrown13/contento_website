defmodule Mix.Tasks.Contento.Install.Theme do
  use Mix.Task

  require Logger

  import Mix.Ecto

  alias Contento.Themes

  @base_path "priv/themes"
  @config_filename "theme.json"

  def run(args) do
    ensure_started(Contento.Repo, [])

    repo = Enum.at(args, 0)

    with {:ok, _} <- clone_theme(repo),
         {:ok, config} <- theme_config(repo),
         :ok <- copy_assets(repo),
         {:ok, theme} <- Themes.create_theme(config) do
      Logger.info("Theme #{theme.name} installed successfully!")
    else
      err -> Mix.raise("#{inspect err}")
    end
  end

  defp clone_theme(repo) do
    dest = Path.join(@base_path, theme_alias(repo))

    Task.async(fn ->
      cmd("git", ["clone", repo, dest])
    end)
    |> Task.await()
  end

  defp theme_config(repo) do
    path = Path.join([@base_path, theme_alias(repo), @config_filename])

    with {:ok, config} <- File.read(path) do
      config = config
      |> Poison.decode!()
      |> Map.merge(%{
        "alias" => theme_alias(repo)
      })

      {:ok, config}
    end
  end

  defp theme_alias(repo), do: Path.basename(repo, ".git")

  defp copy_assets(repo) do
    orig_path = Path.join([@base_path, theme_alias(repo), "assets"])
    dest_path = Path.join("priv/static/themes", theme_alias(repo))

    with {:ok, _} <- cmd("mkdir", ["-p", "priv/static/themes"]),
         {:ok, _} <- cmd("cp", ["-rf", orig_path, dest_path]), do: :ok
  end

  defp cmd(command, args) do
    Task.async(fn ->
      {output, exit_status} = System.cmd(command, args)

      output = String.replace(output, "\n", "")

      if exit_status != 0 do
        {:error, output}
      else
        {:ok, output}
      end
    end)
    |> Task.await(:infinity)
  end
end
