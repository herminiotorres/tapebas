defmodule TapebasWeb.Presence do
  @moduledoc false

  use Phoenix.Presence,
    otp_app: :tapebas,
    pubsub_server: Tapebas.PubSub
end
