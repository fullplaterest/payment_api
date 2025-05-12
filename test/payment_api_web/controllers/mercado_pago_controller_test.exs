defmodule PaymentApiWeb.MercadoPagoControllerTest do
  use PaymentApiWeb.ConnCase, async: true

  import Tesla.Mock

  describe "POST /api/qr_code_mercado_pago" do
    test "retorna 201 e json esperado quando sucesso", %{conn: conn} do
      mock(fn
        %{method: :post, url: "/173913148/pos/PLATE001POS001/qrs"} ->
          %Tesla.Env{
            status: 201,
            body: %{"qr_code" => "abc123", "external_reference" => "ref-001"}
          }
      end)

      params = %{
        "external_reference" => "12345",
        "title" => "Pagamento no QR",
        "description" => "Compra de produtos",
        "total_amount" => 100,
        "items" => [%{"title" => "Produto A", "unit_price" => 100, "quantity" => 1}],
        "cash_out" => %{"amount" => 0}
      }

      conn = post(conn, "/api/qr_code_mercado_pago", params)

      assert json_response(conn, 201) == %{
               "status" => "requested",
               "in_store_order_id" => nil,
               "qr_data" => nil
             }
    end

    test "retorna 400 quando erro na API do Mercado Pago", %{conn: conn} do
      mock(fn _ ->
        %Tesla.Env{status: 400, body: %{"message" => "invalid amount"}}
      end)

      params = %{
        "external_reference" => "12345",
        "title" => "Pagamento no QR",
        "description" => "Compra de produtos",
        "total_amount" => 100,
        "items" => [%{"title" => "Produto A", "unit_price" => 100, "quantity" => 1}],
        "cash_out" => %{"amount" => 0}
      }

      conn = post(conn, "/api/qr_code_mercado_pago", params)

      assert json_response(conn, 500)["errors"] == "Internal Server Error"
    end

    test "retorna 500 quando falha de rede", %{conn: conn} do
      mock(fn _ -> {:error, :timeout} end)

      params = %{
        "external_reference" => "12345",
        "title" => "Pagamento no QR",
        "description" => "Compra de produtos",
        "total_amount" => 100,
        "items" => [%{"title" => "Produto A", "unit_price" => 100, "quantity" => 1}],
        "cash_out" => %{"amount" => 0}
      }

      conn = post(conn, "/api/qr_code_mercado_pago", params)

      assert json_response(conn, 500)["errors"] == "Internal Server Error"
    end
  end
end
