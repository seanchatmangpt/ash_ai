defmodule AshAiTest do
  use ExUnit.Case
  import Mock
  doctest AshAi

  alias Twitter.Support.User

  setup do
    # Properly create a test user using Ash.Changeset and Ash.create
    test_user =
      User
      |> Ash.Changeset.for_create(:create, %{
        username: "test_user",
        email: "test@example.com",
        age: 25
      })
      |> Ash.create!()

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
end
