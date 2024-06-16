defmodule CreativeWeb.ContactLive.Index do
  use CreativeWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Contacts
      <:actions>
        <.link patch={~p"/contacts/new"}>
          <.button>New Contact</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="contacts"
      rows={@streams.contacts}
      row_click={fn {_id, contact} -> JS.navigate(~p"/contacts/#{contact}") end}
    >
      <:col :let={{_id, contact}} label="First name">
        <%= contact.first_name %>
      </:col>

      <:col :let={{_id, contact}} label="Last name"><%= contact.last_name %></:col>

      <:col :let={{_id, contact}} label="Birth date">
        <%= contact.birth_date %>
      </:col>

      <:col :let={{_id, contact}} label="Phone"><%= contact.phone %></:col>

      <:col :let={{_id, contact}} label="Email"><%= contact.email %></:col>

      <:action :let={{_id, contact}}>
        <div class="sr-only">
          <.link navigate={~p"/contacts/#{contact}"}>Show</.link>
        </div>

        <.link patch={~p"/contacts/#{contact}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, contact}}>
        <.link
          phx-click={JS.push("delete", value: %{id: contact.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="contact-modal"
      show
      on_cancel={JS.patch(~p"/contacts")}
    >
      <.live_component
        module={CreativeWeb.ContactLive.FormComponent}
        id={(@contact && @contact.id) || :new}
        title={@page_title}
        action={@live_action}
        contact={@contact}
        patch={~p"/contacts"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :contacts, fetch_contacts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Contact")
    |> assign(:contact, Ash.get!(Creative.Contacts.Contact, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Contact")
    |> assign(:contact, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Contacts")
    |> assign(:contact, nil)
  end

  @impl true
  def handle_info(
        {CreativeWeb.ContactLive.FormComponent, {:saved, contact}},
        socket
      ) do
    {:noreply, stream_insert(socket, :contacts, contact)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    contact = Ash.get!(Creative.Contacts.Contact, id)
    Ash.destroy!(contact)

    {:noreply, stream_delete(socket, :contacts, contact)}
  end

  defp fetch_contacts do
    Creative.Contacts.Contact
    |> Ash.Query.sort([:first_name])
    |> Ash.read!()
  end
end
