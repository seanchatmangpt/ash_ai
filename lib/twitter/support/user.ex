defmodule Twitter.Support.User do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: Twitter.Support,
    extensions: [AshJsonApi.Resource]

  # Define attributes for the resource
  attributes do
    # Primary key
    uuid_primary_key(:id)

    # Username of the user, required
    attribute :username, :string do
      allow_nil?(false)
    end

    # Email of the user, required
    attribute :email, :string do
      allow_nil?(false)
    end

    # Timestamps
    attribute(:inserted_at, :utc_datetime_usec, default: &DateTime.utc_now/0)
    attribute(:updated_at, :utc_datetime_usec, default: &DateTime.utc_now/0)

    # Add a new attribute for age
    attribute(:age, :integer)
  end

  # Define relationships
  relationships do
    has_many(:tweets, Twitter.Support.Tweet)
  end

  # identities do
  # identity(:unique_email, [:email])
  # identity(:unique_username, [:username])
  # end

  # Add global validations
  validations do
    # Ensure username is present and has a minimum length
    validate(string_length(:username, min: 3))

    # Ensure email is present and matches a basic email pattern
    validate(match(:email, ~r/@/))

    # Ensure age is present and the user is at least 13 years old
    validate(compare(:age, greater_than_or_equal_to: 13))
  end

  # Define actions to operate on the resource
  actions do
    # Default actions for creating, reading, updating, and destroying users
    defaults([:read, :destroy])

    # Custom create action with input validation
    create :create do
      accept([:username, :email, :age])
    end

    # Custom update action with specific inputs
    update :update do
      accept([:username, :email, :age])
    end

    # Custom read action to retrieve a tweet by ID
    read :read_by_id do
      argument(:id, :uuid, allow_nil?: false)
      filter(expr(id == ^arg(:id)))
      get?(true)
    end

    read :read_by_username do
      argument(:username, :string, allow_nil?: false)
      filter(expr(username == ^arg(:username)))
      get?(true)
    end

    create :create_user do
      accept([:username, :email, :age])
      upsert?(true)
      upsert_identity(:unique_username)
    end
  end

  code_interface do
    define(:read)
    define(:create, args: [:username, :email, :age])
    define(:update, args: [:username, :email, :age])
    define(:destroy)
    define(:read_by_id, args: [:id])
    define(:read_by_username, args: [:username])
  end

  # JSON API configuration
  json_api do
    type("user")

    routes do
      base("/users")
      get(:read)
      index(:read)
      post(:create)
      patch(:update)
      delete(:destroy)
    end
  end
end
