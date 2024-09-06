defmodule AshAiReadTest do
  use ExUnit.Case
  import Mock
  doctest AshAi

  alias Twitter.Support.User

  setup do
    # Properly create a test user using Ash.Changeset and Ash.create
    test_user = User.create!("test_user", "test@example.com", 25)

    {:ok, test_user: test_user}
  end

  test "AI invokes correct action for reading user by username and handles completion", %{
    test_user: test_user
  } do
    # Define the list of mocked responses
    mocked_responses = [
      %{
        "choices" => [
          %{
            "message" => %{
              "tool_calls" => [
                %{
                  "function" => %{
                    "name" => "Twitter_Support_User-read_by_username",
                    "arguments" => "{\"username\":\"test_user\"}"
                  },
                  "id" => "1"
                }
              ]
            }
          }
        ]
      },
      %{
        "choices" => [
          %{
            "finish_reason" => "stop",
            "message" => %{"content" => "Completed the task successfully"}
          }
        ]
      }
    ]

    # Start the MockResponseManager with the list of mocked responses
    {:ok, _pid} = MockResponseManager.start_link(mocked_responses)

    # Mock the OpenaiEx.Chat.Completions module
    :meck.new(OpenaiEx.Chat.Completions, [:passthrough])

    # Expect the mocked function to return responses sequentially
    :meck.expect(OpenaiEx.Chat.Completions, :create!, fn _client, _req ->
      # Fetch the next response from the MockResponseManager
      MockResponseManager.get_next_response()
    end)

    System.put_env("OPENAI_API_KEY", "test_key")

    # Call AshAi with a prompt that should lead to the read_by_username action
    response =
      AshAi.instruct!("Find user by username test_user",
        actor: test_user,
        actions: [{Twitter.Support.User, :*}]
      )

    # Validate that the function exited correctly and returned the expected content
    assert response == "Completed the task successfully"

    # Unload the mocked module
    :meck.unload(OpenaiEx.Chat.Completions)
  end
end
