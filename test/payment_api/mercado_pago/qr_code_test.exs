defmodule PaymentApi.MercadoPago.QrCodeTest do
  use ExUnit.Case, async: true
  import Mox

  setup :verify_on_exit!

  test "create_qr/3 returns success when API responds with 201" do
    payload = %{amount: 100, description: "Compra"}

    Tesla.Mock.mock(fn
      %{method: :post, url: "/173913148/pos/PLATE001POS001/qrs"} ->
        %Tesla.Env{status: 201, body: %{"qr_code" => "abc123"}}
    end)

    assert PaymentApi.MercadoPago.QrCode.create_qr(payload) == {:ok, %{"qr_code" => "abc123"}}
  end

  test "create_qr/3 returns error with status" do
    payload = %{amount: 100, description: "Compra"}

    Tesla.Mock.mock(fn _ ->
      %Tesla.Env{status: 400, body: %{"message" => "invalid request"}}
    end)

    assert PaymentApi.MercadoPago.QrCode.create_qr(payload) ==
             {:error, %{status: 400, response: %{"message" => "invalid request"}}}
  end

  test "create_qr/3 handles request failure" do
    payload = %{amount: 100, description: "Compra"}

    Tesla.Mock.mock(fn _ -> {:error, :timeout} end)

    assert PaymentApi.MercadoPago.QrCode.create_qr(payload) == {:error, :timeout}
  end
end
