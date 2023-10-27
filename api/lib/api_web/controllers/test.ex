defmodule ApiWeb.TestController do
  use ApiWeb, :controller
  alias ApiWeb.Guardian

  def get_token(conn, _params) do
    user = Api.Accounts.get_user!(1)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)

    dbg(jwt)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{token: jwt}))
  end
end
