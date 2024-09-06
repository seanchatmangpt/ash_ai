defmodule Twitter.Support do
  @moduledoc """
  A module for domain-specific logic that supports the Twitter app.
  """
  use Ash.Domain, extensions: [AshJsonApi.Domain]


  resources do
    resource(Twitter.Support.Tweet)
    resource(Twitter.Support.User)
  end
end
