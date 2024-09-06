defmodule AshAiTest do
  use ExUnit.Case
  import Mock
  doctest AshAi

  alias Twitter.Support.{User, Tweet}

  setup do
    # Create a test user using the Twitter.Support.User resource
    {:ok, test_user} =
      User.create(
        "test_user",
        "test@example.com",
        25
      )

    {:ok, test_user: test_user}
  end

  test "instruct! returns a response", %{test_user: test_user} do
    with_mocks([
      {OpenaiEx, [],
       [
         new: fn _apikey -> %{} end
       ]},
      {OpenaiEx.Chat.Completions, [],
       [
         new: fn _opts -> %{} end,
         create!: fn _client, _req ->
           %{
             "choices" => [
               %{
                 "message" => %{
                   "tool_calls" => [
                     %{
                       "function" => %{
                         "name" => "complete",
                         "arguments" => Jason.encode!(%{message: "Test response"})
                       }
                     }
                   ]
                 }
               }
             ]
           }
         end
       ]}
    ]) do
      System.put_env("OPENAI_API_KEY", "test_key")

      assert AshAi.instruct!("Test prompt",
               actor: test_user,
               actions: [{Twitter.Support.User, :*}]
             ) == "Test response"
    end
  end

  test "creates a user account" do
    test_user = %{id: "test_user_id"}

    with_mocks([
      {OpenaiEx, [],
       [
         new: fn _apikey -> %{} end
       ]},
      {OpenaiEx.Chat.Completions, [],
       [
         new: fn _opts -> %{} end,
         create!: fn _client, _req ->
           %{
             "choices" => [
               %{
                 "message" => %{
                   "tool_calls" => [
                     %{
                       "function" => %{
                         "name" => "Twitter_Support-Twitter_Support_User-create",
                         "arguments" => %{
                           "input" => %{
                             "username" => "jane_doe",
                             "email" => "jane.doe@example.com",
                             "age" => 30
                           }
                         }
                       }
                     }
                   ]
                 }
               }
             ]
           }
         end
       ]},
      {Twitter.Support.User, [],
       [
         create: fn _username, _email, _age ->
           {:ok, %Twitter.Support.User{
             username: "jane_doe",
             email: "jane.doe@example.com",
             age: 30
           }}
         end
       ]}
    ]) do
      System.put_env("OPENAI_API_KEY", "test_key")

      result =
        AshAi.instruct!("Create the Jane Doe account",
          actor: test_user,
          actions: [{Twitter.Support.User, :*}]
        )

      assert result == "The account for Jane Doe has been successfully created."

      # Verify that the user was actually created
      created_user = User.read_by_username!("jane_doe")
      assert created_user.email == "jane.doe@example.com"
      assert created_user.age == 30
    end
  end



  test "updates user age" do
    test_user = %{id: Ash.UUID.generate()}

    with_mocks([
      {OpenaiEx, [],
       [
         new: fn _apikey -> %{} end
       ]},
      {OpenaiEx.Chat.Completions, [],
       [
         new: fn _opts -> %{} end,
         create!: fn _client, _req ->
           %{
             "choices" => [
               %{
                 "message" => %{
                   "tool_calls" => [
                     %{
                       "function" => %{
                         "name" => "Twitter_Support-Twitter_Support_User-update",
                         "arguments" =>
                           Jason.encode!(%{
                             input: %{
                               id: "746192d9-58d9-48b6-a843-7ca31917f599",
                               age: 38
                             }
                           })
                       }
                     },
                     %{
                       "function" => %{
                         "name" => "complete",
                         "arguments" =>
                           Jason.encode!(%{
                             message: "The user's age has been successfully updated to 38, along with their existing email and username. Is there anything else you would like to do?"
                           })
                       }
                     }
                   ]
                 }
               }
             ]
           }
         end
       ]}
    ]) do
      System.put_env("OPENAI_API_KEY", "test_key")

      result =
        AshAi.instruct!(
          "Update the 746192d9-58d9-48b6-a843-7ca31917f599 account age to 38",
          actor: test_user,
          actions: [{Twitter.Support.User, :*}]
        )

      assert result == "The user's age has been successfully updated to 38, along with their existing email and username. Is there anything else you would like to do?"

      # Verify that the user was actually updated
      updated_user = User.get!("746192d9-58d9-48b6-a843-7ca31917f599")
      assert updated_user.age == 38
      assert updated_user.email == "jane.doe@example.com"
      assert updated_user.username == "jane_doe"
    end
  end
end
