defmodule UspAvaliaWeb.Charts do
  alias Contex.BarChart
  use Phoenix.Component

  attr :id, :string, required: true
  attr :type, :string, default: "line"
  attr :width, :integer, default: nil
  attr :height, :integer, default: nil
  attr :animated, :boolean, default: false
  attr :toolbar, :boolean, default: false
  attr :dataset, :list, default: []
  attr :categories, :list, default: []

  def line_graph(assigns) do
    ~H"""
    <div
      id={@id}
      class="[&>div]:mx-auto"
      phx-hook="Chart"
      data-config={
        Jason.encode!(
          trim(%{
            height: @height,
            width: @width,
            type: @type,
            animations: %{
              enabled: @animated
            },
            toolbar: %{
              show: @toolbar
            }
          })
        )
      }
      data-series={Jason.encode!(@dataset)}
      data-categories={Jason.encode!(@categories)}
    >
    </div>
    """
  end

  attr :id, :string, required: true
  attr :labels, :list, required: true
  attr :series, :list, required: true
  attr :title, :string, required: false, default: ""

  def simple_pie_chart(assigns) do
    ~H"""
    <div
      id={@id}
      phx-hook="Chart"
      data-labels={Jason.encode!(@labels)}
      data-series={Jason.encode!(@series)}
      data-title={@title}
    >
    </div>
    """
  end

  attr :id, :string, required: true
  attr :labels, :list, required: true
  attr :series, :list, required: true
  attr :title, :string, required: false, default: ""

  def simple_column_chart(assigns) do
    ~H"""
    <div
      id={@id}
      phx-hook="ColumnChart"
      data-categories={Jason.encode!(@labels)}
      data-series={Jason.encode!(@series)}
      data-title={@title}
    >
    </div>
    """
  end

  defp trim(map) do
    Map.reject(map, fn {_key, val} -> is_nil(val) || val == "" end)
  end
end
