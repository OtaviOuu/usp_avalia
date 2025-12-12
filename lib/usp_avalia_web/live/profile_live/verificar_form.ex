defmodule UspAvaliaWeb.ProfileLive.VerificarForm do
  alias Phoenix.LiveView
  use UspAvaliaWeb, :live_view

  alias UspAvalia.Avaliacoes

  on_mount {UspAvaliaWeb.UserAuth, :require_authenticated}
  on_mount {UspAvaliaWeb.UserAuth, :require_email_usp}
  on_mount {UspAvaliaWeb.UserAuth, :require_no_open_pedido_validacao}

  def mount(_params, _session, socket) do
    scope = socket.assigns.current_scope

    create_verification_form =
      Avaliacoes.change_pedido_validacao(%{}, scope) |> to_form(as: "pedido_verificacao")

    socket =
      socket
      |> assign(:create_verification_form, create_verification_form)
      |> assign(:uploaded_files, [])
      |> allow_upload(:foto_carteirinha, accept: ~w(.jpg .jpeg .png), max_entries: 1)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="max-w-2xl mx-auto p-4">
        <h1 class="text-2xl font-bold mb-4">Verificar Perfil</h1>
        <img :for={img <- @uploaded_files} src={img} class="mb-4 max-h-64" />
        <p class="mb-4">
          Para garantir a autenticidade das avaliações, apenas alunos da USP podem
          submeter avaliações. Por favor, verifique seu perfil USP para continuar.
        </p>

        <.form
          for={@create_verification_form}
          phx-change="change"
          phx-submit="save"
          id="verification-form"
        >
          <.input
            type="textarea"
            field={@create_verification_form[:numero_usp]}
            label="Justificativa"
            placeholder="Numero USP"
            rows="4"
          />
          <div class="mb-2">
            <label class="block text-sm font-medium text-gray-700">Image</label>
            <div
              class="mt-1 flex justify-center rounded-md border-2 border-dashed border-gray-300 px-6 pt-5 pb-6"
              phx-drop-target={@uploads.foto_carteirinha.ref}
            >
              <div class="space-y-1 text-center">
                <.icon name="hero-arrow-up-tray" class="mx-auto h-12 w-12 text-gray-400" />
                <div class="flex text-sm text-gray-600">
                  <label class="relative cursor-pointer rounded-md bg-white font-medium text-primary-600 focus-within:outline-none focus-within:ring-2 focus-within:ring-primary-500 focus-within:ring-offset-2 hover:text-primary-500">
                    <span>Upload a file</span>
                    <.live_file_input upload={@uploads.foto_carteirinha} class="sr-only" />
                  </label>
                  <p class="pl-1">or drag and drop</p>
                </div>
                <p class="text-xs text-gray-500">PNG or JPG</p>
              </div>
            </div>
          </div>
          <%= for entry <- @uploads.foto_carteirinha.entries do %>
            <figure>
              <.live_img_preview entry={entry} />
              <figcaption>{entry.client_name}</figcaption>
            </figure>
            <p>
              <progress value={entry.progress} max="100">{entry.progress}% </progress>
            </p>

            <p :for={err <- upload_errors(@uploads.foto_carteirinha, entry)}>
              {error_to_string(err)}
            </p>
          <% end %>
          <.input
            type="textarea"
            field={@create_verification_form[:informacoes_adicionais]}
            label="Informações Adicionais (opcional)"
            placeholder="Caso queira adicionar alguma informação adicional, utilize este campo."
            rows="4"
          />
          <.button>Save</.button>
        </.form>
      </div>
    </Layouts.app>
    """
  end

  def handle_event("change", %{"pedido_verificacao" => _pedido_verificacao_params}, socket) do
    {:noreply, socket}
  end

  def handle_event("save", %{"pedido_verificacao" => attrs}, socket) do
    {:ok, file_path} = handle_carteirinha_upload(socket)

    attrs = Map.put(attrs, "foto_carteirinha", file_path)

    IO.inspect(attrs, label: "Attrs with file path")

    case Avaliacoes.create_pedido_validacao(
           attrs,
           socket.assigns.current_scope
         ) do
      {:ok, _pedido_verificacao} ->
        {:noreply,
         socket
         |> put_flash(:info, "Pedido de verificação criado com sucesso.")
         |> push_navigate(to: ~p"/disciplinas")}

      {:error, changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Erro ao criar o pedido de verificação. Tente novamente.")
         |> assign(
           :create_verification_form,
           to_form(changeset, as: "pedido_verificacao", action: :validate)
         )}
    end
  end

  def handle_carteirinha_upload(socket) do
    file_path =
      consume_uploaded_entries(socket, :foto_carteirinha, fn %{path: path}, _entry ->
        base_dir = :code.priv_dir(:usp_avalia) |> to_string()
        directory = Path.join([base_dir, "static", "uploads"])

        File.mkdir_p!(directory)

        filename = Path.basename(path)
        dest = Path.join(directory, filename)

        File.cp!(path, dest)

        {:ok, "/uploads/#{filename}"}
      end)
      |> List.first()

    {:ok, file_path}
  end

  def error_to_string(:too_large), do: "Image too large"
  def error_to_string(:too_many_files), do: "Too many files"
  def error_to_string(:not_accepted), do: "Unacceptable file type"
end
