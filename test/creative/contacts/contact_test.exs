defmodule Creative.Contacts.ContactTests do
  use Creative.DataCase

  alias Creative.TestContextAgent
  alias Creative.Contacts.Contact

  import Creative.ContactsFixtures

  describe "code_interfaces" do
    @invalid_attrs %{first_name: nil}

    setup do
      {:ok, _pid} = TestContextAgent.start_link()
      :ok
    end

    setup do
      contact = contact_fixture()
      %{contact: contact}
    end

    @tag :contact_resource
    test "Contact.list/0 lists all contacts", %{contact: contact} do
      {:ok, [c]} = Contact.list()
      assert c.id == contact.id
    end

    @tag :contact_resource
    test "Contact.get/1 get the contact", %{contact: contact} do
      {:ok, c} = Contact.get(contact.id)
      assert c.id == contact.id
    end

    @tag :contact_resource
    test "Contact.create/1 with invalid attrs renders an error" do
      assert {:error, %Ash.Error.Invalid{}} = Contact.create(@invalid_attrs)
    end

    @tag :contact_resource
    test "Contact.create/1 with valid attrs creates a new contact" do
      name = unique_first_name()

      {:ok, contact} =
        Contact.create(contact_valid_attrs(%{first_name: name}))

      {:ok, c} = Contact.get(contact.id)

      assert c.first_name == contact.first_name
    end

    @tag :contact_resource
    test "Contact.update/2 with invalid attrs renders an error", %{
      contact: contact
    } do
      {:error, %Ash.Error.Invalid{}} =
        Contact.update(contact.id, @invalid_attrs)
    end

    @tag :contact_resource
    test "contact.update/2 with valid attrs updates the contact", %{
      contact: contact
    } do
      name = unique_first_name()

      {:ok, contact} = Contact.update(contact.id, %{first_name: name})
      {:ok, c} = Contact.get(contact.id)

      assert c.first_name == contact.first_name
    end

    @tag :contact_resource
    test "contact.delete/1 deletes the contact", %{contact: contact} do
      :ok = Contact.delete(contact.id)
      assert {:error, %Ash.Error.Query.NotFound{}} = Contact.get(contact.id)
    end
  end
end
