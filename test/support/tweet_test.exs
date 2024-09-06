defmodule Twitter.Support.TweetTest do
  use ExUnit.Case, async: true
  alias Twitter.Support.Tweet

  setup do
    # Initialize the ETS data layer for testing
    :ets.new(Tweet, [:named_table, :set, :public])
    :ok
  end

  describe "create/2" do
    test "creates a tweet with valid attributes" do
      {:ok, tweet} = Tweet.create("Hello, world!", Ecto.UUID.generate())

      assert tweet.content == "Hello, world!"
      assert tweet.status == :draft
      assert tweet.id
      assert tweet.user_id
    end

    test "fails to create a tweet with missing content" do
      assert {:error, _} = Tweet.create(nil, Ecto.UUID.generate())
    end

    test "fails to create a tweet with invalid user_id" do
      assert {:error, _} = Tweet.create("Valid content", "invalid-uuid")
    end
  end

  describe "read_by_id/1" do
    setup do
      {:ok, tweet} = Tweet.create("Read this tweet", Ecto.UUID.generate())
      {:ok, tweet: tweet}
    end

    test "retrieves a tweet by ID", %{tweet: tweet} do
      {:ok, found_tweet} = Tweet.read_by_id(tweet.id)

      assert found_tweet.id == tweet.id
      assert found_tweet.content == "Read this tweet"
    end

    test "returns an error when tweet is not found" do
      assert {:error, _} = Tweet.read_by_id("non-existent-id")
    end
  end

  describe "update/3" do
    setup do
      {:ok, tweet} = Tweet.create("Initial tweet", Ecto.UUID.generate())
      {:ok, tweet: tweet}
    end

    test "updates a tweet with valid attributes", %{tweet: tweet} do
      # Correct usage: Pass the tweet ID, changes, and options (empty list)
      {:ok, updated_tweet} = Tweet.update(tweet, "Updated tweet")

      assert updated_tweet.content == "Updated tweet"
    end

    test "fails to update a tweet with missing content", %{tweet: tweet} do
      assert {:error, _} = Tweet.update(tweet, %{content: nil}, [])
    end
  end

  describe "destroy/2" do
    setup do
      {:ok, tweet} = Tweet.create("Tweet to be deleted", Ecto.UUID.generate())
      {:ok, tweet: tweet}
    end

    test "destroys a tweet successfully", %{tweet: tweet} do
      # Correct usage: Pass the tweet ID and options (empty list)
      assert :ok = Tweet.destroy(tweet)
      assert {:error, _} = Tweet.read_by_id(tweet.id)
    end

    test "fails to destroy a non-existent tweet" do
      assert {:error, _} = Tweet.destroy("non-existent-id", [])
    end
  end

  describe "read_by_user/1" do
    setup do
      user_id = Ecto.UUID.generate()
      {:ok, tweet1} = Tweet.create("First tweet", user_id)
      {:ok, tweet2} = Tweet.create("Second tweet", user_id)
      {:ok, tweets: [tweet1, tweet2], user_id: user_id}
    end

    test "retrieves tweets by user ID", %{tweets: [tweet1, tweet2], user_id: user_id} do
      {:ok, tweets} = Tweet.read_by_user(user_id)
      assert length(tweets) == 2
      assert Enum.any?(tweets, fn tweet -> tweet.id == tweet1.id end)
      assert Enum.any?(tweets, fn tweet -> tweet.id == tweet2.id end)
    end

    test "returns an empty list for a user with no tweets" do
      {:ok, tweets} = Tweet.read_by_user(Ecto.UUID.generate())
      assert tweets == []
    end
  end
end
