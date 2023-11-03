defmodule Api.Auth.CSRFCheck do
  alias Api.Auth.Guardian
  import Logger
  import Plug.Conn
  def init(options), do: options

  def call(conn, _options) do
    conn = fetch_session(conn) # Ensure the session is fetched

    # Extract the JWT from the Authorization header
    jwt = get_req_header(conn, "authorization")
          |> List.first()
          |> extract_jwt()

    # Fetch the cookies
    cookies = conn
              |> fetch_cookies()
              |> Map.get(:cookies, %{}) # Safely get the cookies map

    # Attempt to get the CSRF token from the cookies
    csrf_token = Map.get(cookies, "csrf_token")

    # Then you would continue with your logic, for example:
    case {jwt, csrf_token} do
      {_, nil} ->
        conn
        |> send_resp(403, "CSRF token not found.")
        |> halt()

      {jwt, csrf_token} when is_binary(jwt) and is_binary(csrf_token) ->
        case Guardian.decode_and_verify(jwt, %{}) do
          {:ok, claims} ->
            # Extract the CSRF token from the claims
            csrf_token_from_claims = Map.get(claims, "csrf_token")

            if csrf_token_from_claims == csrf_token do
              conn
            else
              conn
              |> send_resp(403, "CSRF token does not match the expected value.")
              |> halt()
            end

          {:error, reason} ->
            handle_error(conn, reason)
        end
    end
  end


  defp extract_jwt(header) do
    header
    |> String.split(" ", parts: 2)
    |> List.last()
  end

  defp handle_error(conn, {:jwt, :invalid_signature}) do
    conn
    |> send_resp(403, "Invalid JWT signature.")
    |> halt()
  end
  defp handle_error(conn, {:jwt, :invalid_token}) do
    conn
    |> send_resp(403, "Invalid JWT token.")
    |> halt()
  end
  defp handle_error(conn, {:jwt, reason}) do
    conn
    |> send_resp(403, "JWT error: #{inspect(reason)}.")
    |> halt()
  end
  defp handle_error(conn, %FunctionClauseError{} = e) do
    Logger.error("FunctionClauseError while decoding JWT: #{inspect e}")
    conn
    |> send_resp(403, "Error decoding JWT: #{inspect e}")
    |> halt()
  end
  defp handle_error(conn, _other_error) do
    conn
    |> send_resp(500, "An unexpected error occurred.")
    |> halt()
  end
end
