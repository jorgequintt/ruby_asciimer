require 'rmagick'
include Magick

require './custom_functions'
require './classes/Layer'
require './classes/Cell'
require './classes/ColorReader'

class Canvas
   attr_accessor :layers, :size
   def initialize(base_image, columns, tall_font: false, font_family: "Px437 IBM CGAthin")
      @layers = []
      @tall_font = tall_font
      @font_family = font_family

      # Calcularting W and H of base layer
      pimg = base_image.resize_to_fit(columns)
      raise "Row not divisible by 2" if pimg.rows % 2 > 0
      @size = {:w => pimg.columns, :h => pimg.rows }
      
      # create base layer and set colors from pixel image
      self.create_layer()
      @layers[0].setColors(pimg)

   end

   def create_layer(scale_factor = 1)
      @layers.push(Layer.new(scale_factor, @size, @tall_font, @font_family))
   end

   # def stack_layers()
   #    mask_matrix = Array.new(@size[:h]){Array.new(@size[:w]{false})
   #    _layers = @layers.reverse
   #    _layers.each do |l|
   #       l.scale
   #       each_matrix_index(l) do |ri, ci, p|
   #          # TODO REDO all this, i think. Consider tall_font, and to make it run on demand
   #          # if mask_matrix[ri][ci]
   #          if p[:cell].text == "" || !p[:cell].text then
   #             if l.scale == 1 then 
   #                mask_matrix[ri][ci] = true 
   #             end
   #             if l.scale > 1 then
   #                matrix_area(mask_matrix, ci, ri, l.scale, l.scale) do |rri, cci, pp|
   #                   pp[:cell] = true
   #                end
   #             end
   #          end
   #       # end
   #    end #end each layer
   # end #end method

   def render(final_width, x_margin = 0, y_margin = 0, padding = 0, color: 'black')
      # Create the render image basic grid for resizing
      target = Image.new(@size[:w], @size[:h]) {
         self.background_color = color
         self.colorspace = SRGBColorspace
      }

      # Calculating target width without floating point and resize
      exact_width = final_width * (@size[:w] * 8)
      # exact_width = (final_width / @size[:w]).to_i * @size[:w]
      target = target.resize_to_fit(exact_width)
      
      # Canvas dimensions for later use, so we can add margin
      canvas_width = target.columns
      canvas_height = target.rows

      # We add margin for each side (*2)
      target = target.resize_to_fill(canvas_width + (x_margin*2), canvas_height + (y_margin*2))

      @layers.each do |l|
         tall = l.tall_font

         # current layer/grid
         grid = l.grid

         # Establish cell sizes (not quantity)
         cells = {:x => canvas_width / l.size[:w], :y => canvas_height / l.size[:h]}
         font = l.font
         font.pointsize = cells[:y] - padding

         # for each cell in layer
         each_matrix_index(grid) do |ri, ci|
            cell = grid[ri][ci]

            # calculate X and Y position given the margin
            x = ci * cells[:x] + x_margin
            y = ri * cells[:y] + y_margin

            # Draw text
            font.annotate(target, cells[:x], cells[:y], x, y, cell.text) {
               self.fill = cell.color
            }
         end
      end

      # end of iteration of layers
      target.write('./images/render.png')
   end
end
