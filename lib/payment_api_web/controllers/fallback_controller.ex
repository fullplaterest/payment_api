defmodule PaymentApiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use PaymentApiWeb, :controller

  require Logger

  def call(conn, {:error, :bad_request}) do
    Logger.error("Error fallback bad_request")

    conn
    |> put_status(:bad_request)
    |> put_view(json: PaymentApiWeb.Jsons.ErrorJson)
    |> render(:error, layout: false, reason: "Bad Request")
  end

  def call(conn, {:error, {:unprocessable_entity, reason}}) do
    Logger.error("Error fallback unprocessable_entity. Reason: #{inspect(reason)}")

    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: PaymentApiWeb.Jsons.ErrorJson)
    |> render(:error, layout: false, reason: reason)
  end

  def call(conn, {:error, :not_found}) do
    Logger.error("Error fallback not_found")

    conn
    |> put_status(:not_found)
    |> put_view(json: PaymentApiWeb.Jsons.ErrorJson)
    |> render(:error, layout: false, reason: "Not Found")
  end

  def call(conn, {:error, :unauthorized}) do
    Logger.error("Error invalid access")

    conn
    |> put_status(:unauthorized)
    |> put_view(json: PaymentApiWeb.Jsons.ErrorJson)
    |> render(:error, layout: false, reason: "unauthorized")
  end

  def call(conn, {:error, %{status: status, response: %{"errors" => error}}}) do
    Logger.error("Error fallback #{inspect(error)}")

    conn
    |> put_status(status)
    |> put_view(json: PaymentApiWeb.Jsons.ErrorJson)
    |> render(:error, layout: false, reason: error)
  end

  def call(conn, error) do
    Logger.error("Error fallback #{inspect(error)}")

    conn
    |> put_status(:internal_server_error)
    |> put_view(json: PaymentApiWeb.Jsons.ErrorJson)
    |> render(:error, layout: false, reason: "Internal Server Error")
  end
end
