defmodule Bugsnex.Exception do
  @derive [Poison.Encoder]
  @type t :: %Bugsnex.Exception{}
  defstruct [:errorClass, :message, :stacktrace]
end
