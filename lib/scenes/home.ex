defmodule Daydream.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Scenic.ViewPort

  import Scenic.Primitives

  # ============================================================================
  # setup
  # ============================================================================
  def init(_, opts) do
    {:ok, %ViewPort.Status{size: {width, height}}} = ViewPort.info(opts[:viewport])

    texture = Scenic.Utilities.Texture.build!(:rgb, width, height)

    0..height-1 |> Enum.each(fn row ->
      0..width-1 |> Enum.each(fn col ->
         texture |> Scenic.Utilities.Texture.put!(col, row, computer_pixel_color(row, col, width, height))
      end)
    end)

    {:ok, hash} = Scenic.Cache.Dynamic.Texture.put("hash", texture)

    graph = Graph.build() |> rectangle({ width, height }, fill: { :dynamic, hash })

    {:ok, graph, push: graph}
  end

  def handle_input(_event, _context, state) do
    {:noreply, state}
  end

  defp computer_pixel_color(0, 0, _w, _h) do
    {0, 0, 0}
  end

  defp computer_pixel_color(row, col, w, h) do
    Daydream.Util.compute_rgb_tuple({(col / w), (row / h), 0.25})
  end
end
