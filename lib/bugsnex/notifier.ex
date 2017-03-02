defmodule Bugsnex.Notifier do
  @moduledoc false

  @endpoint 'https://notify.bugsnag.com'
  @content_type 'application/json'
  @http_options [{:ssl, [{:verify, :verify_none}]}]

  @api_key "c9d60ae4c7e70c4b6c4ebd3e8056d2b8"

  @spec notify(Bugsnex.Event.t) :: term
  def notify(event) do
    {:ok, body} = Poison.encode(event)
    :httpc.request(:post, {@endpoint, [], @content_type, body}, @http_options, [])
  end
end
