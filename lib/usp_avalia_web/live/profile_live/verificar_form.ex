defmodule UspAvaliaWeb.ProfileLive.VerificarForm do
  use UspAvaliaWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="max-w-2xl mx-auto p-4">
        <h1 class="text-2xl font-bold mb-4">Verificar Perfil</h1>
        <p class="mb-4">
          Para garantir a autenticidade das avaliações, apenas alunos da USP podem
          submeter avaliações. Por favor, verifique seu perfil USP para continuar.
        </p>
      </div>
    </Layouts.app>
    """
  end
end
