defmodule BugsnagElixir.Event do
  @moduledoc false

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
  Create a new BugsnagElixir.Event structure

    iex> BugsnagElixir.Event.new
    %BugsnagElixir.Event{
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
    ...>   e in ArgumentError -> BugsnagElixir.Event.new(e, [])
    ...> end
    %BugsnagElixir.Event{
      payloadVersion: "2",
      exceptions: [%BugsnagElixir.Exception{errorClass: ArgumentError, message: "Hello, world!", stacktrace: []}],
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
  def new(exception, stacktrace \\ System.stacktrace)
  def new(exception = %BugsnagElixir.Exception{}, _) do
    %__MODULE__{exceptions: [exception]}
  end
  def new(exception, stacktrace) do
    new(BugsnagElixir.Exception.new(exception, stacktrace))
  end

  @doc ~S"""
  Add an exception to the event send to Bugsnag

    iex> BugsnagElixir.Event.put_exception(nil, nil)
    {:error, :no_event}

    iex> BugsnagElixir.Event.put_exception({:error, :no_event}, nil)
    {:error, :no_event}

    iex> BugsnagElixir.Event.new |> BugsnagElixir.Event.put_exception(nil)
    %BugsnagElixir.Event{
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
    ...>   e in ArgumentError -> BugsnagElixir.Event.new |> BugsnagElixir.Event.put_exception(e, [])
    ...> end
    %BugsnagElixir.Event{
      payloadVersion: "2",
      exceptions: [%BugsnagElixir.Exception{errorClass: ArgumentError, message: "Hello, world!", stacktrace: []}],
      context: nil,
      severity: "error",
      user: %{},
      app: nil,
      device: nil,
      metaData: %{}
    }
  """
  @spec put_exception(__MODULE__.t, Exception.t) :: __MODULE__.t | {:error, :no_exception}
  def put_exception(event, exception, stacktrace \\ System.stacktrace)
  def put_exception(nil, _, _), do: {:error, :no_event}
  def put_exception({:error, reason}, _, _), do: {:error, reason}
  def put_exception(event, nil, _), do: event
  def put_exception(event, exception, stacktrace) do
    %__MODULE__{exceptions: exceptions} = event
    %__MODULE__{event | exceptions: [BugsnagElixir.Exception.new(exception, stacktrace) | exceptions]}
  end

  @doc ~S"""
  Add metadata to the event send to Bugsnag

    iex> BugsnagElixir.Event.put_metadata(nil, nil)
    {:error, :no_event}

    iex> BugsnagElixir.Event.put_metadata({:error, :no_event}, nil)
    {:error, :no_event}

    iex> BugsnagElixir.Event.new |> BugsnagElixir.Event.put_metadata(nil)
    %BugsnagElixir.Event{
      payloadVersion: "2",
      exceptions: [],
      context: nil,
      severity: "error",
      user: %{},
      app: nil,
      device: nil,
      metaData: %{}
    }

    iex> BugsnagElixir.Event.new |> BugsnagElixir.Event.put_metadata(%{})
    %BugsnagElixir.Event{
      payloadVersion: "2",
      exceptions: [],
      context: nil,
      severity: "error",
      user: %{},
      app: nil,
      device: nil,
      metaData: %{}
    }

    iex> BugsnagElixir.Event.new |> BugsnagElixir.Event.put_metadata(%{key: 1})
    %BugsnagElixir.Event{
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

    iex> BugsnagElixir.Event.put_user(nil, nil)
    {:error, :no_event}

    iex> BugsnagElixir.Event.put_user({:error, :no_event}, nil)
    {:error, :no_event}

    iex> BugsnagElixir.Event.new |> BugsnagElixir.Event.put_user(nil)
    %BugsnagElixir.Event{
      payloadVersion: "2",
      exceptions: [],
      context: nil,
      severity: "error",
      user: %{},
      app: nil,
      device: nil,
      metaData: %{}
    }

    iex> BugsnagElixir.Event.new |> BugsnagElixir.Event.put_user(%{})
    %BugsnagElixir.Event{
      payloadVersion: "2",
      exceptions: [],
      context: nil,
      severity: "error",
      user: %{},
      app: nil,
      device: nil,
      metaData: %{}
    }

    iex> BugsnagElixir.Event.new |> BugsnagElixir.Event.put_user(%{id: 1, name: "JCVD", email: "jc@vd.com"})
    %BugsnagElixir.Event{
      payloadVersion: "2",
      exceptions: [],
      context: nil,
      severity: "error",
      user: %{id: 1, name: "JCVD", email: "jc@vd.com"},
      app: nil,
      device: nil,
      metaData: %{}
    }

    iex> BugsnagElixir.Event.new
    ...> |> BugsnagElixir.Event.put_user(%{id: 1, name: "JCVD", email: "jc@vd.com"})
    ...> |> BugsnagElixir.Event.put_user(%{id: 2, name: "JCVD", email: "jc@vd.com"})
    %BugsnagElixir.Event{
      payloadVersion: "2",
      exceptions: [],
      context: nil,
      severity: "error",
      user: %{id: 2, name: "JCVD", email: "jc@vd.com"},
      app: nil,
      device: nil,
      metaData: %{}
    }

    iex> BugsnagElixir.Event.new |> BugsnagElixir.Event.put_user(%{id: 1, fullname: "JCVD", email: "jc@vd.com"})
    %BugsnagElixir.Event{
      payloadVersion: "2",
      exceptions: [],
      context: nil,
      severity: "error",
      user: %{},
      app: nil,
      device: nil,
      metaData: %{}
    }
  """
  @spec put_user(__MODULE__.t, keyword) :: __MODULE__.t | {:error, :no_user}
  def put_user(nil, _), do: {:error, :no_event}
  def put_user({:error, reason}, _), do: {:error, reason}
  def put_user(event, nil), do: event
  def put_user(event, user = %{id: _, name: _, email: _}), do: %__MODULE__{event | user: user}
  def put_user(event, %{}), do: event

  @doc ~S"""
  Add app info into BugsnagElixir event

    iex> BugsnagElixir.Event.put_app(nil, nil)
    {:error, :no_event}

    iex> BugsnagElixir.Event.put_app({:error, :no_event}, nil)
    {:error, :no_event}
  """
  @spec put_app(__MODULE__.t, keyword) :: __MODULE__.t | {:error, :no_app}
  def put_app(nil, _), do: {:error, :no_event}
  def put_app({:error, reason}, _), do: {:error, reason}
  def put_app(event, nil), do: event
  def put_app(event, app) when map_size(app) == 0, do: event
  def put_app(event, app = %{version: _, releaseStage: _, type: _}), do: %__MODULE__{event | app: app}
  def put_app(event, %{}), do: event

  @doc ~S"""
  Add device info into BugsnagElixir event

    iex> BugsnagElixir.Event.put_device(nil, nil)
    {:error, :no_event}

    iex> BugsnagElixir.Event.put_device({:error, :no_event}, nil)
    {:error, :no_event}
  """
  @spec put_device(__MODULE__.t, keyword) :: __MODULE__.t | {:error, :no_device}
  def put_device(nil, _), do: {:error, :no_event}
  def put_device({:error, reason}, _), do: {:error, reason}
  def put_device(event, nil), do: event
  def put_device(event, device) when map_size(device) == 0, do: event
  def put_device(event, device = %{osVersion: _, hostname: _}), do: %__MODULE__{event | device: device}
  def put_device(event, %{}), do: event
end
