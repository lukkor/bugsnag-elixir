defmodule Bugsnex.Notifier do
  @moduledoc false

  require Logger

  @endpoint 'https://notify.bugsnag.com'
  @content_type 'application/json'
  @http_options [{:ssl, [{:verify, :verify_none}]}]

  @spec notify(Bugsnex.Event.t) :: term
  def notify(event) do
    with {:ok, body} <- Poison.encode(Bugsnex.Payload.new(event)) do
      case :httpc.request(:post, {@endpoint, [], @content_type, body}, @http_options, []) do
        {:ok, {status_line, _, _}} -> Logger.info(status_line |> Tuple.to_list |> Enum.join(" "))
        {:error, error} -> Logger.debug(error)
      end
    end
  end
end
