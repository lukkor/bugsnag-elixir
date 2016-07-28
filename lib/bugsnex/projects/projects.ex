defmodule Bugsnex.Projects do
  def project(id) do
    Bugsnex.get("/projects/" <> id)
  end
end
