defmodule Daydream.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Scenic.ViewPort

  alias Daydream.Types.Ray

  import Scenic.Primitives

  @dims Application.get_env(:daydream, :dims)

  # ============================================================================
  # setup
  # ============================================================================
  def init(_, opts) do
    {:ok, %ViewPort.Status{size: {width, height}}} = ViewPort.info(opts[:viewport])

    texture = Scenic.Utilities.Texture.build!(:rgb, width, height)

    {:ok, hash} = Scenic.Cache.Dynamic.Texture.put("hash", texture)

    graph = Graph.build() |> rectangle({ width, height }, fill: { :dynamic, hash })

    0..height-1 |> Enum.each(fn row ->
      0..width-1 |> Enum.each(fn col ->
         texture |> Scenic.Utilities.Texture.put!(col, row, computer_pixel_color(row, col, width, height))
      end)
    end)

    state = %{
      hash: hash,
      texture: texture,
      width: width,
      height: height,
      graph: graph,
    }

    {:ok, state, push: graph}
  end

  def handle_info({:push_pixel, {row, col, w, h, color}}, state) do
    texture = state.texture
      |> Scenic.Utilities.Texture.put!(col, row, color)
    graph = state.graph
      |> rectangle({ w, h }, fill: { :dynamic, state.hash })
    Scenic.Cache.Dynamic.Texture.put("hash", texture)
    {:noreply, %{state | texture: texture}, push: graph}
  end

  def handle_input(_event, _context, state) do
    {:noreply, state}
  end

  defp computer_pixel_color(0, 0, _w, _h) do
    {0, 0, 0}
  end

  defp computer_pixel_color(row, col, w, h) do
    {u, v} = {col / (w), row / (h)}

    fc = {0, 0, @dims[:focal_length]}
    lv = Vector.divide(@dims[:vert], 2)
    lh = Vector.divide(@dims[:horz], 2)

    lower_left = Vector.subtract(@dims[:origin], lh)
      |> Vector.subtract(lv)
      |> Vector.subtract(fc)

    uH = Vector.multiply(@dims[:horz], u)
    vV = Vector.multiply(@dims[:vert], v) |> Vector.subtract(@dims[:origin])
    comb = Vector.add(uH, vV)

    ray = %Ray{
      origin: @dims[:origin],
      direction: Vector.add(lower_left, comb)
    }

    ray_color = Ray.ray_color(ray)

    Daydream.Util.compute_rgb_tuple(ray_color)
  end
end
