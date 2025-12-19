defmodule UspAvaliaWeb.VerificacoesAuth do
  def on_mount(:require_can_open_pedido_verificacao, _params, _session, socket) do
    scope = socket.assigns.current_scope

    case UspAvalia.ProfilesVerifications.can_create_pedido_validacao?(scope) do
      true ->
        {:cont, socket}

      false ->
        socket =
          socket
          |> Phoenix.LiveView.put_flash(
            :error,
            "Você não pode criar um novo pedido de verificação no momento."
          )
          |> Phoenix.LiveView.push_navigate(to: "/disciplinas")

        {:halt, socket}
    end
  end
end
