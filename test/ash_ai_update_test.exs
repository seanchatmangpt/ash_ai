defmodule AshAiUpdateTest do
  use ExUnit.Case
  doctest AshAi

  alias Twitter.Support.User

  setup do
    # Create a test user using Ash.Changeset and Ash.create
    test_user = User.create!("test_user", "test@example.com", 25)

    {:ok, test_user: test_user}
  end

  test "AI correctly updates Jane Doe's age", %{test_user: test_user} do
    # First, create Jane Doe's account
    jane_doe =
      User
      |> Ash.Changeset.for_create(:create, %{
        username: "jane_doe",
        email: "jane.doe@example.com",
        age: 30
      })
      |> Ash.create!()

    # Define the list of mocked responses for the update action
    mocked_responses = [
      %{
        "choices" => [
          %{
            "message" => %{
              "tool_calls" => [
                %{
                  "function" => %{
                    "name" => "Twitter_Support_User-update",
                    "arguments" => "{\"id\":\"#{jane_doe.id}\", \"input\": {\"age\": 38}}"
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
            "message" => %{"content" => "The user's age has been successfully updated to 38."}
          }
        ]
      }
    ]

    # Start the MockResponseManager with the mocked responses
    {:ok, _pid} = MockResponseManager.start_link(mocked_responses)

    # Mock the OpenaiEx.Chat.Completions module
    :meck.new(OpenaiEx.Chat.Completions, [:passthrough])

    # Expect the mocked function to return responses sequentially
    :meck.expect(OpenaiEx.Chat.Completions, :create!, fn _client, _req ->
      # Fetch the next response from the MockResponseManager
      MockResponseManager.get_next_response()
    end)

    System.put_env("OPENAI_API_KEY", "test_key")

    # Call AshAi to update Jane Doe's age
    response =
      AshAi.instruct!("Update the Jane Doe account age to 38",
        actor: test_user,
        actions: [{Twitter.Support.User, :*}]
      )

    # Validate that the response matches the expected outcome
    assert response == "The user's age has been successfully updated to 38."

    # Unload the mocked module
    :meck.unload(OpenaiEx.Chat.Completions)
  end
end
