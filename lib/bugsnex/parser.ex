defmodule Bugsnex.Parser do
  @moduledoc false

  @doc ~S"""
  Parses given exception into serializable one

  ## Examples

    iex> Bugsnex.Parser.parse(nil)
    {:error, :no_exception}

    iex> try do
    ...>   raise "Hello, world!"
    ...> rescue
    ...>   e in RuntimeError -> Bugsnex.Parser.parse(e, [])
    ...> end
    {
      :ok,
      %Bugsnex.Exception{
        errorClass: RuntimeError,
        message: "Hello, world!",
        stacktrace: []
      }
    }

    iex> try do
    ...>   raise ArgumentError, "Wrong argument!"
    ...> rescue
    ...>   e in ArgumentError -> Bugsnex.Parser.parse(e, [])
    ...> end
    {
      :ok,
      %Bugsnex.Exception{
        errorClass: ArgumentError,
        message: "Wrong argument!",
        stacktrace: []
      }
    }
  """
  @spec parse(Exception.t, keyword) :: Bugsnex.Exception.t
  def parse(e, st \\ System.stacktrace)
  def parse(nil, _), do: {:error, :no_exception}
  def parse(e, st) do
    {:ok, do_parse(e, st)}
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
