defmodule UspAvalia.Avaliacoes do
  alias UspAvalia.Avaliacoes.Repo

  defdelegate list_disciplinas, to: Repo.Disciplina, as: :get_all
end
