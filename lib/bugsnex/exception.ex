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
      stacktrace: stacktrace(st)
    }
  end

  defp stacktrace(st) do
    st |> Enum.map(&stacktrace_line/1)
  end

  @default_stacktrace_line %{file: "unknown", lineNumber: 0, columnNumber: 0, method: "unknown"}
  defp stacktrace_line(nil), do: @default_stacktrace_line
  defp stacktrace_line({_module, function_name, args, [file: file, line: line_number]}) do
    %{file: List.to_string(file), lineNumber: line_number, columnNumber: 0, method: function(function_name, args)}
  end
  defp stacktrace_line(_), do: @default_stacktrace_line

  defp function(function_name, args) when is_integer(args), do: "#{function_name}/#{args}"
  defp function(function_name, _), do: function_name
end
