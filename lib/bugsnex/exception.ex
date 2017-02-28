defmodule Bugsnex.Exception do
  @moduledoc false

  @derive [Poison.Encoder]
  @type t :: %__MODULE__{}
  defstruct [:errorClass, :message, :stacktrace]

  @doc ~S"""
  Create a Bugsnex.Exception struct given the exception

    iex> Bugsnex.Exception.new(nil)
    %Bugsnex.Exception{}

    iex> try do
    ...>   raise ArgumentError, "Wrong argument!"
    ...> rescue
    ...>   e in ArgumentError -> Bugsnex.Exception.new(e, [])
    ...> end
    %Bugsnex.Exception{
      errorClass: ArgumentError,
      message: "Wrong argument!",
      stacktrace: []
    }
  """
  @spec new(Exception.t, keyword) :: __MODULE__.t
  def new(exception, stacktrace \\ System.stacktrace)
  def new(nil, _), do: %__MODULE__{}
  def new(exception, stacktrace) do
    do_parse(exception, stacktrace)
  end

  defp do_parse(e, st) do
    %Bugsnex.Exception{
      errorClass: e.__struct__,
      message: Exception.message(e),
      stacktrace: do_parse_stacktrace(st)
    }
  end

  defp do_parse_stacktrace(st) do
    st |> Enum.map(&do_parse_stacktrace_line/1)
  end

  defp do_parse_stacktrace_line(nil) do
    %{file: "unknown", lineNumber: 0, columnNumber: 0, method: "unknown"}
  end

  defp do_parse_stacktrace_line({_module, function, _args, [file: file, line: line_number]}) do
    %{file: file, lineNumber: line_number, columnNumber: 0, method: function}
  end

  defp do_parse_stacktrace_line(_) do
    %{file: "unknown", lineNumber: 0, columnNumber: 0, method: "unknown"}
  end
end
