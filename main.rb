require 'rubygems'
require 'rmagick'
include Magick

# local imports
require './classes/Canvas'

puts "Working..."


# boilerplate
base_image = img = Image.read("./images/render2.png")[0]
# base_image = base_image.resize_to_fill(1100, 1100)
canvas = Canvas.new(base_image, 74)
# canvas = Canvas.new(base_image, 160, tall_font: true, font_family: "Consolas")
layers = canvas.layers

# customization
base_string = File.open("./string.txt").read
layers[0].setString(base_string)

canvas.render(3, 120, 120, 3, color: 'black')