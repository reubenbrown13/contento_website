defmodule ContentoWeb.Plug.Website do
  use Guardian.Plug.Pipeline, otp_app: :contento

  plug Guardian.Plug.VerifySession
end
