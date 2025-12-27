defmodule UspAvaliaWeb.ProfessoresJSON do
  alias UspAvalia.Avaliacoes.Professor

  def index(%{professores: professores}) do
    %{
      data: Enum.map(professores, &data/1)
    }
  end

  defp data(%Professor{} = professor) do
    %{
      id: professor.id,
      nome: professor.nome,
      email: professor.email,
      salario: professor.salario
    }
  end
end
