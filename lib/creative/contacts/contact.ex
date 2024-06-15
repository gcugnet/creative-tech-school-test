defmodule Creative.Contacts.Contact do
  use Ash.Resource,
    domain: Creative.Contacts,
    data_layer: AshPostgres.DataLayer

  # This section defines which table will represent this resource in the database.
  postgres do
    table "contacts"
    repo Creative.Repo
  end

  # This section defines every field of the "contacts" table.
  attributes do
    uuid_primary_key :id
    attribute :first_name, :ci_string, allow_nil?: false
    attribute :last_name, :ci_string
    attribute :birth_date, :date

    attribute :phone, :string do
      constraints match: ~r/^\d+$/
    end

    attribute :email, :ci_string do
      constraints match: ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$/
    end

    create_timestamp :inserted_at, type: :utc_datetime
    update_timestamp :updated_at, type: :utc_datetime
  end

  # This section defines unique constraints.
  identities do
    identity :full_name, [:first_name, :last_name], nils_distinct?: false
    identity :phone, [:phone]
    identity :email, [:email]
  end

  # This section defines functions we can call directly like
  # Creative.Contacts.Contact.list()
  code_interface do
    define :list, action: :read
    define :get, action: :read, get_by: :id
    define :create
    define :update
    define :delete, action: :destroy
  end

  # This section defines actions to interract with the resource.
  actions do
    default_accept [
      :first_name,
      :last_name,
      :birth_date,
      :phone,
      :email
    ]

    defaults [:create, :read, :update, :destroy]
  end
end
