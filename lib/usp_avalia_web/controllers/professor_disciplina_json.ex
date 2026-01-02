defmodule UspAvaliaWeb.ProfessorDisciplinaJSON do
  alias UspAvalia.Avaliacoes.Avaliacao

  def show(%{avaliacoes: avaliacoes}) do
    %{
      data: Enum.map(avaliacoes, &avaliacao_data/1)
    }
  end

  defp avaliacao_data(%Avaliacao{} = avaliacao) do
    %{
      id: avaliacao.id,
      comentario_geral: avaliacao.comentario_geral
    }
  end
end
