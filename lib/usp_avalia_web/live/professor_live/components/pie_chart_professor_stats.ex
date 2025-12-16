defmodule UspAvaliaWeb.ProfessorLive.Components.PieChartProfessorStats do
  use UspAvaliaWeb, :live_component
  alias Contex.Dataset

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> make_pie_plot()

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-base-100 p-2">
      {raw(@svg)}
    </div>
    """
  end

  def make_pie_plot(socket) do
    dataset = Dataset.new([["Positivo", 50], ["Negativo", 50]], ["Professor", "Avaliacao"])

    opts = [
      mapping: %{category_col: "Professor", value_col: "Avaliacao"},
      colour_palette: ["fbb4ae", "b3cde3", "ccebc5"],
      data_labels: true
    ]

    plot = Contex.Plot.new(dataset, Contex.PieChart, 600, 400, opts)
    svg = Contex.Plot.to_svg(plot)
    assign(socket, svg: svg)
  end
end
