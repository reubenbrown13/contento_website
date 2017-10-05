defmodule Mix.Tasks.Contento.Build.Assets do
  use Mix.Task

  def run(_args) do
    Mix.Shell.cmd("cd assets && yarn install && yarn build", fn output ->
      Mix.Shell.IO.info(output)
    end)
  end
end
