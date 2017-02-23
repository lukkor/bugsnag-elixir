defmodule Bugsnex.Parser do
  @moduledoc false

  @spec parse(Exception.t) :: Bugsnex.Exception.t
  def parse(_exception) do
    %Bugsnex.Exception{errorClass: "RuntimeError", message: "Runtime error", stacktrace: []}
  end
end
