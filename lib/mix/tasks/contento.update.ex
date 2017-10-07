defmodule Mix.Tasks.Contento.Update do
  use Mix.Task

  require Logger

  @repo "https://github.com/contentocms/contento.git"
  @branch "master"

  def run(_args) do
    Logger.info("Updating Contento from #{@repo}...")

    Mix.Shell.cmd("git --version", fn("git version " <> git_version) ->
      git_version
      |> normalize_git_version()
      |> update()
    end)

    Logger.info("Done updating!")
  end

  defp update(:gt) do
    Mix.Shell.cmd("git remote add contento-update #{@repo}", output())
    Mix.Shell.cmd("git fetch contento-update", output())
    Mix.Shell.cmd("git merge --allow-unrelated-histories contento-update/#{@branch}", output())
    Mix.Shell.cmd("git remote remove contento-update", output())
  end
  defp update(:eq) do
    update(:gt)
  end
  defp update(:lt) do
    Mix.Shell.cmd("git remote add contento-update #{@repo}", output())
    Mix.Shell.cmd("git fetch contento-update", output())
    Mix.Shell.cmd("git merge contento-update/#{@branch}", output())
    Mix.Shell.cmd("git remote remove contento-update", output())
  end
  defp update(git_version) do
    version_with_unrelated_histories = Version.parse!("2.9.0")
    update(Version.compare(git_version, version_with_unrelated_histories))
  end

  defp normalize_git_version(version) do
    version
    |> String.replace_suffix("\n", "")
    |> Version.parse!()
  end

  defp output, do: fn(output) -> Logger.info(output) end
end
