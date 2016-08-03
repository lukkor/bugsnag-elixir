defmodule Bugsnex.Accounts do
  @moduledoc """
  The Accounts module allows you to get information about Bugsnag accounts.
  """

  alias Bugsnex.Account, as: Account

  @doc """
  Create an Account structure from currently authenticated Bugsnag account.

  Returns Account

  ## Example

    iex> Bugsnex.Accounts.get
    %Bugsnex.Account{created_at: "2016-04-22T14:31:36.464Z", id: "571a35c87m6p622f48000b3", name: "Something"}

  """
  def get do
    Account.new(account)
  end

  defp account do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = Bugsnex.get("/account")

    body
  end
end
