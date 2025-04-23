defmodule PaymentApiWeb.Jsons.MercadoPagoJson do
  def mercado_pago_qr_code(%{payload: payload, status: status}) do
    %{
      in_store_order_id: payload["in_store_order_id"],
      qr_data: payload["qr_data"],
      status: status
    }
  end
end
