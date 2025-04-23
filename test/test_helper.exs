ExUnit.start()
Application.put_env(:mox, :verify_on_exit, true)
Application.put_env(:payment_api, :qr_code_module, PaymentApi.MercadoPago.QrCode.Mock)
