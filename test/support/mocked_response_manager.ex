defmodule MockResponseManager do
  @moduledoc """
  A module to manage a list of mock responses for tests.
  """

  # Starts the Agent to keep track of the list of responses and the current index
  def start_link(responses) do
    Agent.start_link(fn -> %{responses: responses, index: 0} end, name: __MODULE__)
  end

  # Retrieves the next response from the list and increments the index
  def get_next_response do
    Agent.get_and_update(__MODULE__, fn state ->
      # Fetch the next response
      response = Enum.at(state.responses, state.index)
      # Increment the index for the next call
      new_state = %{state | index: state.index + 1}
      {response, new_state}
    end)
  end
end
