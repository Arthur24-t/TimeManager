defmodule Api.Auth.FetchCurrentUser do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _options) do
    # Guardian.Plug.current_resource/1 returns the current user
    current_user = Guardian.Plug.current_resource(conn)

    # Assign the current user to the connection
    assign(conn, :current_user, current_user)
  end
end
