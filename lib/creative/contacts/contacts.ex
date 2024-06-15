defmodule Creative.Contacts do
  use Ash.Domain

  # We define Resources managed under this Domain.
  resources do
    resource Creative.Contacts.Contact
  end
end
