defmodule CreativeWeb.ContactLive.Show do
  use CreativeWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Contact <%= @contact.id %>
      <:subtitle>This is a contact record from your database.</:subtitle>

      <:actions>
        <.link
          patch={~p"/contacts/#{@contact}/show/edit"}
          phx-click={JS.push_focus()}
        >
          <.button>Edit Contact</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Id"><%= @contact.id %></:item>

      <:item title="First name"><%= @contact.first_name %></:item>

      <:item title="Last name"><%= @contact.last_name %></:item>

      <:item title="Birth date"><%= @contact.birth_date %></:item>

      <:item title="Phone"><%= @contact.phone %></:item>

      <:item title="Email"><%= @contact.email %></:item>
    </.list>

    <.back navigate={~p"/contacts"}>Back to contacts</.back>

    <.modal
      :if={@live_action == :edit}
      id="contact-modal"
      show
      on_cancel={JS.patch(~p"/contacts/#{@contact}")}
    >
      <.live_component
        module={CreativeWeb.ContactLive.FormComponent}
        id={@contact.id}
        title={@page_title}
        action={@live_action}
        contact={@contact}
        patch={~p"/contacts/#{@contact}"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:contact, Ash.get!(Creative.Contacts.Contact, id))}
  end

  defp page_title(:show), do: "Show Contact"
  defp page_title(:edit), do: "Edit Contact"
end
