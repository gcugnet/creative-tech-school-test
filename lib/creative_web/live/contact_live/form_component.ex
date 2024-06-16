defmodule CreativeWeb.ContactLive.FormComponent do
  use CreativeWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>
          Use this form to manage contact records in your database.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="contact-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:first_name]} type="text" label="First name" /><.input
          field={@form[:last_name]}
          type="text"
          label="Last name"
        /><.input field={@form[:birth_date]} type="date" label="Birth date" /><.input
          field={@form[:phone]}
          type="text"
          label="Phone"
        /><.input field={@form[:email]} type="text" label="Email" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Contact</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()}
  end

  @impl true
  def handle_event("validate", %{"contact" => contact_params}, socket) do
    {:noreply,
     assign(socket,
       form: AshPhoenix.Form.validate(socket.assigns.form, contact_params)
     )}
  end

  def handle_event("save", %{"contact" => contact_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: contact_params) do
      {:ok, contact} ->
        notify_parent({:saved, contact})

        socket =
          socket
          |> put_flash(
            :info,
            "Contact #{socket.assigns.form.source.type}d successfully"
          )
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{contact: contact}} = socket) do
    form =
      if contact do
        AshPhoenix.Form.for_update(contact, :update, as: "contact")
      else
        AshPhoenix.Form.for_create(Creative.Contacts.Contact, :create,
          as: "contact"
        )
      end

    assign(socket, form: to_form(form))
  end
end
