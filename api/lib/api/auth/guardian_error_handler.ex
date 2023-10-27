defmodule Api.Auth.GuardianErrorHandler do
  import Plug.Conn
  import Jason
  require Logger

  @behaviour Guardian.Plug.ErrorHandler

  def auth_error(conn, {type, reason}, _opts) do
    # Loguer le type et la raison de l'erreur d'authentification
    Logger.error("Erreur d'authentification : #{inspect(type)}, Raison : #{inspect(reason)}")

    message =
      case type do
        :token_not_found ->
          "Token d'authentification manquant"
        :token_invalid ->
          "Token d'authentification invalide"
        :unauthenticated ->
          "Non authentifié"
        _ ->
          "Erreur d'authentification"
      end

    conn
    |> put_status(:unauthorized)
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{message: message}))
    |> halt()
  end
end
