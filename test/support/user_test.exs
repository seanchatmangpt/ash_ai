defmodule Twitter.Support.UserTest do
  use ExUnit.Case, async: true
  alias Twitter.Support.User

  setup do
    # Initialize the ETS data layer for testing
    :ets.new(User, [:named_table, :set, :public])
    :ok
  end

  describe "create/3" do
    test "creates a user with valid attributes" do
      {:ok, user} = User.create("john_doe", "john.doe@example.com", 25)

      assert user.username == "john_doe"
      assert user.email == "john.doe@example.com"
      assert user.age == 25
      assert user.id
    end

    test "fails to create a user with missing username" do
      assert {:error, error} = User.create(nil, "john.doe@example.com", 25)
      assert %Ash.Error.Invalid{errors: [missing_username_error]} = error
      assert missing_username_error.field == :username
    end

    test "fails to create a user with invalid email" do
      assert {:error, error} = User.create("john_doe", "invalid-email", 25)
      assert %Ash.Error.Invalid{errors: [invalid_email_error]} = error
      assert invalid_email_error.field == :email
      assert invalid_email_error.message == "must match ~r/@/"
    end

    test "fails to create a user with age below 13" do
      assert {:error, error} = User.create("john_doe", "john.doe@example.com", 12)
      assert %Ash.Error.Invalid{errors: [age_below_13_error]} = error
      assert age_below_13_error.field == :age
      assert age_below_13_error.message == "must be greater than or equal to %{greater_than_or_equal_to}"
    end

    # test "fails to create a user with duplicate username" do
      # {:ok, _} = User.create("john_doe", "john.doe@example.com", 25)
      # assert {:error, error} = User.create("john_doe", "another.john@example.com", 30)
    # end
  end

  describe "read_by_id/1" do
    setup do
      {:ok, user} = User.create("john_doe", "john.doe@example.com", 25)
      {:ok, user: user}
    end

    test "retrieves a user by ID", %{user: user} do
      # Retrieve the user by ID
      {:ok, found_user} = User.read_by_id(user.id)

      assert found_user.id == user.id
      assert found_user.username == "john_doe"
      assert found_user.email == "john.doe@example.com"
    end

    test "returns an error when user is not found" do
      # Attempt to retrieve a non-existent user
      assert {:error, _} = User.read_by_id("non-existent-id")
    end
  end

  describe "update/4" do
    setup do
      {:ok, user} = User.create("john_doe", "john.doe@example.com", 25)
      {:ok, user: user}
    end

    test "updates a user with valid attributes", %{user: user} do
      # Correct usage: Update the user with new attributes
      {:ok, updated_user} = User.update(user, "jane_doe", "jane.doe@example.com", 26)

      assert updated_user.username == "jane_doe"
      assert updated_user.email == "jane.doe@example.com"
      assert updated_user.age == 26
    end

    test "fails to update a user with missing username", %{user: user} do
      # Attempt to update the user with a missing username
      assert {:error, _} = User.update(user, nil, "jane.doe@example.com", 26)
    end

    test "fails to update a user with invalid email", %{user: user} do
      assert {:error, changeset} = User.update(user, "jane_doe", "invalid-email", 26)
    end

    test "fails to update a user with age below 13", %{user: user} do
      assert {:error, changeset} = User.update(user, "jane_doe", "jane.doe@example.com", 12)
    end

    # test "fails to update a user with an existing username", %{user: user} do
      # {:ok, _} = User.create("jane_doe", "jane.doe@example.com", 30)
      # assert {:error, error} = User.update(user, "jane_doe", "john.new@example.com", 26)
    # end
  end

  describe "destroy/1" do
    setup do
      {:ok, user} = User.create("john_doe", "john.doe@example.com", 25)
      {:ok, user: user}
    end

    test "destroys a user successfully", %{user: user} do
      # Correct usage: Destroy the user by passing the record
      assert :ok = User.destroy(user)
      assert {:error, _} = User.read_by_id(user.id)
    end

    test "fails to destroy a non-existent user" do
      # Attempt to destroy a non-existent user
      assert {:error, _} = User.destroy("non-existent-id")
    end
  end

  # Helper function to extract error messages from a changeset
  defp errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
