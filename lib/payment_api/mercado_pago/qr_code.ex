defmodule PaymentApi.MercadoPago.QrCode do
  @behaviour PaymentApi.MercadoPago.Behaviors
  use Tesla

  @base_url "https://api.mercadopago.com/instore/orders/qr/seller/collectors"
  plug Tesla.Middleware.BaseUrl, @base_url
  plug Tesla.Middleware.JSON

  plug Tesla.Middleware.Headers, [
    {"Authorization",
     "Bearer TEST-5376772499598573-020914-60d1b3ed6cbc95d44337385dfb4aeea3-173913148"}
  ]

  plug Tesla.Middleware.Logger

  defp adapter,
    do: Application.get_env(:payment_api, __MODULE__, [])[:adapter] || Tesla.Adapter.Hackney

  defp client, do: Tesla.client([], adapter())

  def create_qr(payload, user_id \\ "173913148", external_pos_id \\ "PLATE001POS001") do
    url = "/#{user_id}/pos/#{external_pos_id}/qrs"

    case Tesla.post(client(), url, payload) do
      {:ok, %Tesla.Env{status: 201, body: body}} ->
        {:ok, body}

      {:ok, %Tesla.Env{status: status, body: body}} ->
        {:error, %{status: status, response: body}}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
