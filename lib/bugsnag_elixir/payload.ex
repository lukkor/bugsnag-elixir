defmodule BugsnagElixir.Payload do
  @moduledoc false

  @derive [Poison.Encoder]
  @type t :: %__MODULE__{}
  defstruct apiKey: "",
            notifier: %{},
            events: []

  @name "bugsnag-elixir"
  @version Mix.Project.config[:version]
  @url "https://github.com/Lukkor/bugsnag-elixir"

  @api_key Application.get_env(:bugsnag_elixir, :api_token, "c9d60ae4c7e70c4b6c4ebd3e8056d2b8")

  def new(events) when is_list(events) do
    %__MODULE__{
      apiKey: @api_key,
      notifier: notifier(),
      events: events
    }
  end

  def new(event) do
    new([event])
  end

  def notifier do
    %{name: @name, version: @version, url: @url}
  end
end
