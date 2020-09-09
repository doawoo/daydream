defmodule Daydream.Types.Ray do
  use TypedStruct

  typedstruct do
    field :origin, {float(), float(), float()}, enforce: true, default: {0, 0, 0}
    field :direction, {float(), float(), float()}, enforce: true, default: {0, 0, 0}
  end
end
