defmodule Twitter.Support.UserTweetLoadTest do
  use ExUnit.Case, async: true
  alias Twitter.Support.{User, Tweet}

  setup do
    # Initialize the ETS data layers for testing
    :ets.new(User, [:named_table, :set, :public])
    :ets.new(Tweet, [:named_table, :set, :public])
    :ok
  end

  describe "load tweets for users" do
    setup do
      # Create a user and their tweets
      {:ok, user} = User.create("john_doe", "john.doe@example.com", 25)
      {:ok, tweet1} = Tweet.create("Hello, world!", user.id)
      {:ok, tweet2} = Tweet.create("Another tweet", user.id)

      # Return the created user and tweets for use in tests
      {:ok, user: user, tweets: [tweet1, tweet2]}
    end

    test "loads tweets directly on the user record", %{user: user} do
      # Use Ash.load/3 to load tweets for the given user
      {:ok, loaded_user} = Ash.load(user, :tweets)

      # Assert that the loaded user contains the tweets
      assert length(loaded_user.tweets) == 2
      assert Enum.any?(loaded_user.tweets, fn tweet -> tweet.content == "Hello, world!" end)
      assert Enum.any?(loaded_user.tweets, fn tweet -> tweet.content == "Another tweet" end)
    end

    test "loads tweets using a query", %{user: user} do
      # Use Ash.Query.load/2 to load tweets in the query
      query = User |> Ash.Query.load(:tweets)
      {:ok, [loaded_user]} = Ash.read(query)

      # Assert that the loaded user contains the tweets
      assert length(loaded_user.tweets) == 2
      assert Enum.any?(loaded_user.tweets, fn tweet -> tweet.content == "Hello, world!" end)
      assert Enum.any?(loaded_user.tweets, fn tweet -> tweet.content == "Another tweet" end)
    end

    test "loads multiple relationships simultaneously", %{user: user} do
      # Load multiple relationships (only tweets in this case)
      {:ok, loaded_user} = Ash.load(user, [:tweets])

      # Assert that tweets are loaded correctly
      assert length(loaded_user.tweets) == 2
      assert Enum.any?(loaded_user.tweets, fn tweet -> tweet.content == "Hello, world!" end)
      assert Enum.any?(loaded_user.tweets, fn tweet -> tweet.content == "Another tweet" end)
    end
  end
end
