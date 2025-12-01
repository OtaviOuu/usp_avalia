defmodule UspAvaliaWeb.DisciplinasJSON do
  alias UspAvalia.Avaliacoes.Entities.Disciplina

  def index(%{disciplinas: disciplinas}) do
    %{
      data: Enum.map(disciplinas, &data/1)
    }
  end

  defp data(%Disciplina{} = disciplina) do
    %{
      nome: disciplina.nome,
      instituto: disciplina.instituto
    }
  end
end
