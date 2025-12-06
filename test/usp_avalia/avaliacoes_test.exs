defmodule UspAvalia.AvaliacoesTest do
  use UspAvalia.DataCase

  alias UspAvalia.Avaliacoes
  alias UspAvalia.AccountsFixtures
  alias UspAvalia.AvaliacoesFixtures

  describe "create_avaliacao/2" do
    test "create avaliacao with right data" do
      avaliacao_attrs = %{
        nota: 4,
        comentario: "Good professor",
        professor_id: Ecto.UUID.generate(),
        disciplina_id: Ecto.UUID.generate()
      }

      scope = AccountsFixtures.user_scope_fixture()

      {:ok, created_avaliacao} = Avaliacoes.create_avaliacao(scope, avaliacao_attrs)
      IO.inspect(created_avaliacao)
    end
  end
end
