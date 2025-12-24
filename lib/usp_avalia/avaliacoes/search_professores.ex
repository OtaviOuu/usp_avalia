defmodule UspAvalia.Avaliacoes.SearchProfessores do
  alias UspAvalia.Repo

  import Ecto.Query, warn: false
  alias UspAvalia.Avaliacoes.Professor
  alias UspAvalia.Avaliacoes.ProfessoreDisciplina

  # :(
  def call(search_term, disciplina_codigo) do
    query =
      from p in Professor,
        join: pd in ProfessoreDisciplina,
        on: pd.professor_id == p.id,
        where:
          pd.disciplina_codigo == ^disciplina_codigo and
            ilike(p.nome, ^"%#{search_term}%"),
        select: p,
        distinct: p.id,
        limit: 15,
        select_merge: %{
          id: p.id,
          nome: p.nome,
          email: p.email,
          numero_disciplinas:
            fragment(
              "(
            SELECT COUNT(*)
            FROM professores_disciplinas AS pd2
            WHERE pd2.professor_id = ?
          )",
              p.id
            ),
          salario: p.salario
        }

    Repo.all(query)
  end
end
