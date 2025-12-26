defmodule UspAvaliaWeb.DisciplinasJSON do
  alias UspAvalia.Avaliacoes.{Disciplina, Professor}

  def index(%{disciplinas: disciplinas}) do
    %{
      data: Enum.map(disciplinas, &data/1)
    }
  end

  def show(%{disciplina: disciplina}) do
    %{
      data: data(disciplina)
    }
  end

  defp data(%Disciplina{} = disciplina) do
    IO.inspect(disciplina.professores, label: "Professores carregados")

    %{
      nome: disciplina.nome,
      instituto: disciplina.instituto,
      codigo: disciplina.codigo,
      professores: Enum.map(disciplina.professores, &professor_data/1)
    }
  end

  defp professor_data(%Professor{} = professor) do
    %{
      id: professor.id,
      nome: professor.nome,
      email: professor.email,
      salario: professor.salario
    }
  end
end
