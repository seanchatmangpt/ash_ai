defmodule Twitter.Support.Tweet do
  use Ash.Resource,
    # Using ETS for demonstration; replace with AshPostgres for production
    data_layer: Ash.DataLayer.Ets,
    otp_app: :twitter,
    domain: Twitter.Support,
    extensions: [AshJsonApi.Resource]

  # Define code interface for using the resource
  code_interface do
    define(:create, args: [:content, :user_id])
    define(:read_by_id, args: [:id])
    define(:update, args: [:content])
    define(:destroy)
    define(:read_by_user, args: [:user_id])
  end

  # Define actions to operate on the resource
  actions do
    defaults([:read, :destroy])

    # Custom create action with input validation
    create :create do
      accept([:content, :user_id])

      # Define changes to set default status to "draft" if not provided
      change(set_attribute(:status, "draft"))
    end

    # Custom update action with specific inputs
    update :update do
      accept([:content])
    end

    # Custom read action to retrieve a tweet by ID
    read :read_by_id do
      argument(:id, :uuid, allow_nil?: false)
      filter(expr(id == ^arg(:id)))
      get?(true)
    end

    # Custom read action to retrieve tweets by user ID
    read :read_by_user do
      argument(:user_id, :uuid, allow_nil?: false)
      filter(expr(user_id == ^arg(:user_id)))
    end
  end

  # Define attributes for the resource
  attributes do
    # Primary key
    uuid_primary_key(:id)

    # Content of the tweet, required
    attribute :content, :string do
      allow_nil?(false)
    end

    # ID of the user who created the tweet, required
    attribute :user_id, :uuid do
      allow_nil?(false)
    end

    # Status of the tweet (e.g., "draft", "published"), default to "draft"
    attribute :status, :atom do
      allow_nil?(false)
      default(:draft)
      constraints(one_of: [:draft, :published, :deleted])
    end

    attribute(:inserted_at, :utc_datetime_usec, default: &DateTime.utc_now/0)
    attribute(:updated_at, :utc_datetime_usec, default: &DateTime.utc_now/0)
  end

  json_api do
    type("tweet")

    routes do
      base("/tweets")
      get(:read)
      index(:read_by_id)
      post(:create)
      patch(:update)
      delete(:destroy)
    end
  end
end
