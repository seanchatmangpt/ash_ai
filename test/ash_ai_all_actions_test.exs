defmodule AshAiAllActionsTest do
  use ExUnit.Case
  doctest AshAi

  alias Twitter.Support.User

  setup do
    test_user = User.create!("test_user", "test@example.com", 25)

    {:ok, test_user: test_user}
  end

  test "AI performs all actions: create, read, update, destroy", %{test_user: test_user} do
    # Mocked responses for the sequence of actions: create, read, update, destroy
    mocked_responses = [
      # Mock response for creating Jane Doe
      %{
        "choices" => [
          %{
            "message" => %{
              "tool_calls" => [
                %{
                  "function" => %{
                    "name" => "Twitter_Support_User-create",
                    "arguments" => "{\"input\":{\"username\":\"jane_doe\",\"email\":\"jane.doe@example.com\",\"age\":30}}"
                  },
                  "id" => "1"
                }
              ]
            }
          }
        ]
      },
      # Mock response indicating creation is complete
      %{
        "choices" => [
          %{
            "finish_reason" => "stop",
            "message" => %{"content" => "The account for Jane Doe has been successfully created."}
          }
        ]
      },
      # Mock response for reading Jane Doe
      %{
        "choices" => [
          %{
            "message" => %{
              "tool_calls" => [
                %{
                  "function" => %{
                    "name" => "Twitter_Support_User-read",
                    "arguments" => "{\"filter\":{\"username\":\"jane_doe\"}}"
                  },
                  "id" => "2"
                }
              ]
            }
          }
        ]
      },
      # Mock response indicating read is complete
      %{
        "choices" => [
          %{
            "finish_reason" => "stop",
            "message" => %{"content" => "Found user: jane_doe"}
          }
        ]
      },
      # Mock response for updating Jane Doe's age
      %{
        "choices" => [
          %{
            "message" => %{
              "tool_calls" => [
                %{
                  "function" => %{
                    "name" => "Twitter_Support_User-update",
                    "arguments" => "{\"id\":\"746192d9-58d9-48b6-a843-7ca31917f599\", \"input\": {\"age\": 38}}"
                  },
                  "id" => "3"
                }
              ]
            }
          }
        ]
      },
      # Mock response indicating update is complete
      %{
        "choices" => [
          %{
            "finish_reason" => "stop",
            "message" => %{"content" => "The user's age has been successfully updated to 38."}
          }
        ]
      },
      # Mock response for deleting Jane Doe
      %{
        "choices" => [
          %{
            "message" => %{
              "tool_calls" => [
                %{
                  "function" => %{
                    "name" => "Twitter_Support_User-destroy",
                    "arguments" => "{\"id\":\"746192d9-58d9-48b6-a843-7ca31917f599\"}"
                  },
                  "id" => "4"
                }
              ]
            }
          }
        ]
      },
      # Mock response indicating delete is complete
      %{
        "choices" => [
          %{
            "finish_reason" => "stop",
            "message" => %{"content" => "The user jane_doe has been successfully deleted."}
          }
        ]
      }
    ]

    # Start the MockResponseManager with the mocked responses
    {:ok, _pid} = MockResponseManager.start_link(mocked_responses)

    # Mock the OpenaiEx.Chat.Completions module
    :meck.new(OpenaiEx.Chat.Completions, [:passthrough])
    :meck.expect(OpenaiEx.Chat.Completions, :create!, fn _client, _req ->
      MockResponseManager.get_next_response()
    end)

    System.put_env("OPENAI_API_KEY", "test_key")

    # 1. Simulate creating a new user (Jane Doe)
    response_create =
      AshAi.instruct!("Create the Jane Doe account",
        actor: test_user,
        actions: [{Twitter.Support.User, :*}]
      )

    assert response_create == "The account for Jane Doe has been successfully created."

    # 2. Simulate reading the user by username
    response_read =
      AshAi.instruct!("Find user by username jane_doe",
        actor: test_user,
        actions: [{Twitter.Support.User, :*}]
      )

    assert response_read == "Found user: jane_doe"

    # 3. Simulate updating the user's age
    response_update =
      AshAi.instruct!("Update the Jane Doe account age to 38",
        actor: test_user,
        actions: [{Twitter.Support.User, :*}]
      )

    assert response_update == "The user's age has been successfully updated to 38."

    # 4. Simulate deleting the user
    response_destroy =
      AshAi.instruct!("Delete the Jane Doe account",
        actor: test_user,
        actions: [{Twitter.Support.User, :*}]
      )

    assert response_destroy == "The user jane_doe has been successfully deleted."

    # Unload the mocked module
    :meck.unload(OpenaiEx.Chat.Completions)
  end
end
