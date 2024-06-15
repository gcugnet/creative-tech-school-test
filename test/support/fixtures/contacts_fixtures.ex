defmodule Creative.ContactsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Creative.Contacts` domain.
  """

  alias Creative.TestContextAgent
  alias Creative.Contacts.Contact

  @alphabet ?a..?z
  @min_length 3
  @max_length 12

  def unique_first_name do
    generated_name = generate_random_name()

    case TestContextAgent.name_exists?(generated_name) do
      true ->
        unique_first_name()

      false ->
        TestContextAgent.add_name(generated_name)
        generated_name
    end
  end

  defp generate_random_name do
    length = Enum.random(@min_length..@max_length)

    @alphabet |> Enum.take_random(length) |> to_string()
  end

  def unique_phone, do: "#{System.unique_integer([:positive])}"
  def unique_email, do: "name#{System.unique_integer([:positive])}@example.com"

  def contact_valid_attrs(attrs \\ %{}) do
    Enum.into(attrs, %{
      first_name: unique_first_name(),
      phone: unique_phone(),
      email: unique_email()
    })
  end

  def contact_fixture(attrs \\ %{}) do
    contact_valid_attrs = contact_valid_attrs(attrs)

    {:ok, contact} = Contact.create(contact_valid_attrs)

    contact
  end
end
