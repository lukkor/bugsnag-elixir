defmodule Bugsnex.Accounts do
  def accounts do
    Bugsnex.get("/accounts")
  end

  def account do
    Bugsnex.get("/account")
  end

  def account(id) do
    Bugsnex.get("/account/" <> id)
  end
end
