defmodule UspAvaliaWeb.AdminLive.AvaliarPedidos do
  use UspAvaliaWeb, :live_view

  alias UspAvalia.ProfilesVerifications

  def mount(_params, _session, socket) do
    scope = socket.assigns.current_scope

    pedidos =
      case ProfilesVerifications.list_pedidos_verificacao(scope) do
        {:ok, pedidos} -> pedidos
        {:error, _} -> []
      end

    {:ok, assign(socket, pedidos: pedidos)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <h1 class="text-2xl font-bold mb-4">Avaliar Pedidos</h1>

      <div class="overflow-x-auto">
        <table class="table w-full">
          <!-- head -->
          <thead>
            <tr>
              <th class="text-center">Numero USP</th>
              <th class="text-center">Carteirinha</th>
              <th class="text-center">Status</th>
              <th class="text-center">Ações</th>
            </tr>
          </thead>

          <tbody>
            <tr :for={pedido <- @pedidos} class="hover:bg-base-200">
              <td class="text-center">
                <div class="flex flex-col items-center justify-center gap-1">
                  <div class="avatar">
                    <div class="  flex items-center justify-center">
                      <span class="font-medium">{pedido.numero_usp}</span>
                    </div>
                  </div>
                </div>
              </td>

              <td class="text-center">
                <div class="mask mask-squircle h-12 w-12 mx-auto overflow-hidden">
                  <img src={pedido.foto_carteirinha} class="object-cover h-full w-full" />
                </div>
              </td>

              <td class="text-center">
                <div class="flex justify-center">
                  <span class={status_class(pedido.status)}>
                    {String.capitalize(to_string(pedido.status))}
                  </span>
                </div>
              </td>

              <td class="text-center">
                <.button phx-click="approve" phx-value-id={pedido.id} class="btn btn-success btn-xs">
                  <.icon name="hero-check" />
                </.button>
                <.button phx-click="reject" phx-value-id={pedido.id} class="btn btn-error btn-xs">
                  <.icon name="hero-x-mark" />
                </.button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </Layouts.app>
    """
  end

  def handle_event("approve", %{"id" => id}, socket) do
    scope = socket.assigns.current_scope

    with pedido <- Enum.find(socket.assigns.pedidos, &(&1.id == id)),
         {:ok, _updated_pedido} <-
           ProfilesVerifications.change_pedido_verificacao_status(
             pedido,
             :aprovado,
             scope
           ) do
      {:noreply, push_navigate(socket, to: ~p"/admin/avaliar-pedidos")}
    else
      _ -> {:noreply, socket}
    end
  end

  def handle_event("reject", %{"id" => id}, socket) do
    scope = socket.assigns.current_scope

    with pedido <- Enum.find(socket.assigns.pedidos, &(&1.id == id)),
         {:ok, _updated_pedido} <-
           ProfilesVerifications.change_pedido_verificacao_status(
             pedido,
             :rejeitado,
             scope
           ) do
      {:noreply, push_navigate(socket, to: ~p"/admin/avaliar-pedidos")}
    else
      _ -> {:noreply, socket}
    end
  end

  # Mapeamento de status para classes DaisyUI
  defp status_class(:pendente), do: "badge badge-warning"
  defp status_class(:aprovado), do: "badge badge-success"
  defp status_class(:rejeitado), do: "badge badge-error"
  defp status_class(_), do: "badge"
end
