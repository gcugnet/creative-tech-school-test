defmodule CreativeWeb.ContactLiveTest do
  use CreativeWeb.ConnCase

  alias Creative.TestContextAgent

  import Phoenix.LiveViewTest
  import Creative.ContactsFixtures

  @invalid_attrs %{first_name: nil}

  setup do
    {:ok, _pid} = TestContextAgent.start_link()
    :ok
  end

  setup do
    contact = contact_fixture()
    %{contact: contact}
  end

  # -------------------------------------------------------------------------- #
  #                                 Index Page                                  #
  # -------------------------------------------------------------------------- #

  describe "Index" do
    @tag :contact_liveview
    test "visitors CAN list contacts", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/contacts")

      assert html =~ "Listing Contacts"
    end

    @tag :contact_liveview
    test "visitors CAN create a contact from the index page", %{conn: conn} do
      attributes = contact_valid_attrs()
      {:ok, index_live, _html} = live(conn, ~p"/contacts")

      assert index_live |> element("a", "New Contact") |> render_click() =~
               "New Contact"

      assert index_live
             |> form("#contact-form", contact: @invalid_attrs)
             |> render_change() =~ "is required"

      assert index_live
             |> form("#contact-form", contact: attributes)
             |> render_submit()

      assert_patch(index_live, ~p"/contacts")

      html = render(index_live)
      assert html =~ "Contact created successfully"
      assert html =~ "#{attributes.first_name}"
    end

    @tag :contact_liveview
    test "visitors CAN update a contact from the index page", %{
      conn: conn,
      contact: contact
    } do
      updated_name = unique_first_name()
      {:ok, index_live, _html} = live(conn, ~p"/contacts")

      assert index_live |> element("a", "Edit") |> render_click() =~
               "Edit Contact"

      assert index_live
             |> form("#contact-form", contact: @invalid_attrs)
             |> render_change() =~ "is required"

      assert index_live
             |> form("#contact-form", contact: %{first_name: updated_name})
             |> render_submit()

      assert_patch(index_live, ~p"/contacts")

      html = render(index_live)
      assert html =~ "Contact updated successfully"
      assert html =~ "#{contact.email}"
      assert html =~ "#{updated_name}"
    end

    @tag :contact_liveview
    test "visitors CAN delete a contact from the index page", %{
      conn: conn,
      contact: contact
    } do
      {:ok, index_live, _html} = live(conn, ~p"/contacts")

      assert has_element?(index_live, "#contacts-#{contact.id}")

      assert index_live |> element("a", "Delete") |> render_click()

      refute has_element?(index_live, "#contacts-#{contact.id}")
    end
  end

  # -------------------------------------------------------------------------- #
  #                                 Show Page                                  #
  # -------------------------------------------------------------------------- #

  describe "Show" do
    @tag :contact_liveview
    test "visitors CAN see a contact", %{conn: conn, contact: contact} do
      {:ok, _index_live, html} = live(conn, ~p"/contacts/#{contact.id}")

      assert html =~ "#{contact.id}"
    end

    @tag :contact_liveview
    test "visitors CAN update a contact from the show page", %{
      conn: conn,
      contact: contact
    } do
      updated_name = unique_first_name()
      {:ok, index_live, _html} = live(conn, ~p"/contacts/#{contact.id}")

      assert index_live |> element("a", "Edit Contact") |> render_click() =~
               "Edit Contact"

      assert index_live
             |> form("#contact-form", contact: @invalid_attrs)
             |> render_change() =~ "is required"

      assert index_live
             |> form("#contact-form", contact: %{first_name: updated_name})
             |> render_submit()

      assert_patch(index_live, ~p"/contacts/#{contact.id}")

      html = render(index_live)
      assert html =~ "Contact updated successfully"
      assert html =~ "#{contact.email}"
      assert html =~ "#{updated_name}"
    end
  end
end
