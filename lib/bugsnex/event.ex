defmodule Bugsnex.Event do
  @derive [Poison.Encoder]
  @type t :: %__MODULE__{}
  defstruct payloadVersion: "2",
            exceptions: [],
            context: nil,
            severity: "error",
            user: %{},
            app: nil,
            device: nil,
            metaData: %{}

  @doc ~S"""
  Create a new Bugsnex.Event structure

    iex> Bugsnex.Event.new
    %Bugsnex.Event{
      payloadVersion: "2",
      exceptions: [],
      context: nil,
      severity: "error",
      user: %{},
      app: nil,
      device: nil,
      metaData: %{}
    }

    iex> try do
    ...>   raise ArgumentError, "Hello, world!"
    ...> rescue
    ...>   e in ArgumentError -> Bugsnex.Event.new(e)
    ...> end
    %Bugsnex.Event{
      payloadVersion: "2",
      exceptions: [%ArgumentError{message: "Hello, world!"}],
      context: nil,
      severity: "error",
      user: %{},
      app: nil,
      device: nil,
      metaData: %{}
    }
  """
  @spec new(Exception.t | nil) :: __MODULE__.t
  def new, do: %__MODULE__{}
  def new(exception), do: %__MODULE__{exceptions: [exception]}

  @doc ~S"""
  Add an exception to the event send to Bugsnag

    iex> Bugsnex.Event.put_exception(nil, nil)
    {:error, :no_event}

    iex> Bugsnex.Event.put_exception({:error, :no_event}, nil)
    {:error, :no_event}

    iex> Bugsnex.Event.new |> Bugsnex.Event.put_exception(nil)
    %Bugsnex.Event{
      payloadVersion: "2",
      exceptions: [],
      context: nil,
      severity: "error",
      user: %{},
      app: nil,
      device: nil,
      metaData: %{}
    }

    iex> try do
    ...>   raise ArgumentError, "Hello, world!"
    ...> rescue
    ...>   e in ArgumentError -> Bugsnex.Event.new |> Bugsnex.Event.put_exception(e)
    ...> end
    %Bugsnex.Event{
      payloadVersion: "2",
      exceptions: [%ArgumentError{message: "Hello, world!"}],
      context: nil,
      severity: "error",
      user: %{},
      app: nil,
      device: nil,
      metaData: %{}
    }
  """
  @spec put_exception(__MODULE__.t, Exception.t) :: __MODULE__.t | {:error, :no_exception}
  def put_exception(nil, _), do: {:error, :no_event}
  def put_exception({:error, reason}, _), do: {:error, reason}
  def put_exception(event, nil), do: event
  def put_exception(event, exception) do
    %__MODULE__{exceptions: exceptions} = event
    %__MODULE__{event | exceptions: [exception | exceptions]}
  end

  @doc ~S"""
  Add metadata to the event send to Bugsnag

    iex> Bugsnex.Event.put_metadata(nil, nil)
    {:error, :no_event}

    iex> Bugsnex.Event.put_metadata({:error, :no_event}, nil)
    {:error, :no_event}

    iex> Bugsnex.Event.new |> Bugsnex.Event.put_metadata(nil)
    %Bugsnex.Event{
      payloadVersion: "2",
      exceptions: [],
      context: nil,
      severity: "error",
      user: %{},
      app: nil,
      device: nil,
      metaData: %{}
    }

    iex> Bugsnex.Event.new |> Bugsnex.Event.put_metadata(%{})
    %Bugsnex.Event{
      payloadVersion: "2",
      exceptions: [],
      context: nil,
      severity: "error",
      user: %{},
      app: nil,
      device: nil,
      metaData: %{}
    }

    iex> Bugsnex.Event.new |> Bugsnex.Event.put_metadata(%{key: 1})
    %Bugsnex.Event{
      payloadVersion: "2",
      exceptions: [],
      context: nil,
      severity: "error",
      user: %{},
      app: nil,
      device: nil,
      metaData: %{key: 1}
    }
  """
  @spec put_metadata(__MODULE__.t, keyword) :: __MODULE__.t | {:error, :no_metadata}
  def put_metadata(nil, _), do: {:error, :no_event}
  def put_metadata({:error, reason}, _), do: {:error, reason}
  def put_metadata(event, nil), do: event
  def put_metadata(event, new_metadata) when map_size(new_metadata) == 0, do: event
  def put_metadata(event, new_metadata) do
    %__MODULE__{metaData: metadata} = event
    %__MODULE__{event | metaData: Map.merge(metadata, new_metadata)}
  end

  @doc ~S"""
  Add user info to the event send to Bugsnag

    iex> Bugsnex.Event.put_user(nil, nil)
    {:error, :no_event}

    iex> Bugsnex.Event.put_user({:error, :no_event}, nil)
    {:error, :no_event}

    iex> Bugsnex.Event.new |> Bugsnex.Event.put_user(nil)
    %Bugsnex.Event{
      payloadVersion: "2",
      exceptions: [],
      context: nil,
      severity: "error",
      user: %{},
      app: nil,
      device: nil,
      metaData: %{}
    }

    iex> Bugsnex.Event.new |> Bugsnex.Event.put_user(%{})
    %Bugsnex.Event{
      payloadVersion: "2",
      exceptions: [],
      context: nil,
      severity: "error",
      user: %{},
      app: nil,
      device: nil,
      metaData: %{}
    }

    iex> Bugsnex.Event.new |> Bugsnex.Event.put_user(%{key: 1})
    %Bugsnex.Event{
      payloadVersion: "2",
      exceptions: [],
      context: nil,
      severity: "error",
      user: %{key: 1},
      app: nil,
      device: nil,
      metaData: %{}
    }

    iex> Bugsnex.Event.new |> Bugsnex.Event.put_user(%{key: 1}) |> Bugsnex.Event.put_user(%{key: 2})
    %Bugsnex.Event{
      payloadVersion: "2",
      exceptions: [],
      context: nil,
      severity: "error",
      user: %{key: 2},
      app: nil,
      device: nil,
      metaData: %{}
    }
  """
  @spec put_user(__MODULE__.t, keyword) :: __MODULE__.t | {:error, :no_user}
  def put_user(nil, _), do: {:error, :no_event}
  def put_user({:error, reason}, _), do: {:error, reason}
  def put_user(event, nil), do: event
  def put_user(event, user) when map_size(user) == 0, do: event
  def put_user(event, user), do: %__MODULE__{event | user: user}
end
