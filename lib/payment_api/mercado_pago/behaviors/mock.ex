defmodule PaymentApi.MercadoPago.Behaviors do
  @callback create_qr(map(), binary(), binary()) ::
              {:ok, map()} | {:error, any()}
end
