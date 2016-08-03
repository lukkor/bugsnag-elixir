defmodule Bugsnex.Account do
  @moduledoc """
  This module defines Account structure.
  """

  defstruct id: "", name: "", created_at: ""
  use ExConstructor
end
