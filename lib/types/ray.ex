defmodule Daydream.Types.Ray do
  use TypedStruct

  alias __MODULE__

  typedstruct do
    field :origin, {float(), float(), float()}, enforce: true, default: {0, 0, 0}
    field :direction, {float(), float(), float()}, enforce: true, default: {0, 0, 0}
  end

  @spec at(Daydream.Types.Ray.t(), float) :: {number, number} | {number, number, number}
  def at(%Ray{} = ray, t) when is_float(t) do
    Vector.multiply(ray.direction, t)
    |> Vector.add(ray.origin)
  end

  @spec ray_color(Daydream.Types.Ray.t()) :: {number, number} | {number, number, number}
  def ray_color(%Ray{} = ray) do
    {_x, unit_y, _z} = Vector.unit(ray.direction)
    t = 0.5 * (unit_y + 1.0)
    a = Vector.multiply({1.0, 1.0, 1.0}, 1.0 - t)
    b = Vector.multiply({0.5, 0.7, 1.0}, t)
    Vector.add(a, b)
  end
end
