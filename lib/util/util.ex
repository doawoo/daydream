defmodule Daydream.Util do
  @spec compute_rgb_tuple({number, number} | {number, number, number}) ::
          {integer, integer, integer}
  def compute_rgb_tuple({_x, _y, _z} = color) do
    r = Kernel.trunc(Vector.component(color, :x) * 255)
    g = Kernel.trunc(Vector.component(color, :y) * 255)
    b = Kernel.trunc(Vector.component(color, :z) * 255)
    {r, g, b}
  end
end
