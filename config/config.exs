# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

aspect_ratio = 16.0 / 9.0
image_width  = 400

image_height = image_width / aspect_ratio

viewport_height = 2.0
viewport_width = aspect_ratio * viewport_height
focal_length = 1.0

config :daydream, :dims,
  aspect_ratio: aspect_ratio,
  image_width: image_width,
  image_height: image_height,
  viewport_height: viewport_height,
  viewport_width: viewport_width,
  focal_length: focal_length,

  origin: {0.0, 0.0, 0.0},
  horz: {viewport_width, 0.0, 0.0},
  vert: {0.0, viewport_height, 0.0}

# Configure the main viewport for the Scenic application
config :daydream, :viewport, %{
  name: :main_viewport,
  size: {round(image_width), round(400 / aspect_ratio)},
  default_scene: {Daydream.Scene.Home, nil},
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      name: :glfw,
      opts: [resizeable: false, title: "daydream"]
    }
  ]
}

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "prod.exs"
