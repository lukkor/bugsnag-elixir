defmodule Bugsnex.Errors do
  @moduledoc """
  The Errors module allows you to get details about Bugsnag errors.
  """

  @doc """
  Get details about the error identify by given Bugsnag id.
  """
  def error(id) do
    Bugsnex.get("/errors/" <> id)
  end
end
