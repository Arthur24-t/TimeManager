defmodule Api.Auth.Guardian do
  require Logger
  use Guardian, otp_app: :api

  def subject_for_token(resource, _claims) do
    # Vous pouvez utiliser n'importe quel attribut de votre structure utilisateur
    # ici. Par exemple, `resource.id` ou `resource.email`.
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(%{"sub" => id}) do
    {:ok, Api.Accounts.get_user(id)}
  end
end
