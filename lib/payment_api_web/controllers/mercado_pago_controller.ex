defmodule PaymentApiWeb.MercadoPagoController do
  use PaymentApiWeb, :controller

  alias PaymentApi.MercadoPago.QrCode

  action_fallback(PaymentApiWeb.FallbackController)

  plug :put_view, json: PaymentApiWeb.Jsons.MercadoPagoJson

  def create(conn, params) do
    with {:ok, payload} <- QrCode.create_qr(params) do
      conn
      |> put_status(:created)
      |> render(:mercado_pago_qr_code, loyalt: false, payload: payload, status: :requested)
    end
  end
end
