defmodule Bugsnex.Event do
  @derive [Poison.Encoder]
  @type t :: %__MODULE__{}
  defstruct payloadVersion: "2",
            exceptions: [],
            context: nil,
            severity: "error",
            user: nil,
            app: nil,
            device: nil,
            metaData: nil

  @spec new(Exception.t | nil) :: __MODULE__.t
  def new(event \\ nil) do
    %__MODULE__{}
  end

  @spec put_exception(__MODULE__.t, Exception.t) :: __MODULE__.t | {:error, :no_exception}
  def put_exception(nil, _), do: {:error, :no_exception}
  def put_exception({:error, reason}, _), do: {:error, reason}
  def put_exception(event, nil), do: event
  def put_exception(event, {}), do: event
  def put_exception(event, exception) do
    event
  end

  @spec put_metadata(__MODULE__.t, keyword) :: __MODULE__.t | {:error, :no_metadata}
  def put_metadata(nil, _), do: {:error, :no_metadata}
  def put_metadata({:error, reason}, _), do: {:error, reason}
  def put_metadata(event, nil), do: event
  def put_metadata(event, {}), do: event
  def put_metadata(event, metadata) do
    event
  end

  @spec put_user(__MODULE__.t, keyword) :: __MODULE__.t | {:error, :no_user}
  def put_user(nil, _), do: {:error, :no_user}
  def put_user({:error, reason}, _), do: {:error, reason}
  def put_user(event, nil), do: event
  def put_user(event, {}), do: event
  def put_user(event, user) do
    event
  end
end
