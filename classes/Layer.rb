require './classes/Cell'
require './classes/ColorReader'
require './custom_functions'

class Layer
   attr_accessor :font, :scale, :size, :grid, :tall_font

   def initialize(scale_factor, size, tall_font, font_family)
      @tall_font = tall_font
      raise "columns / scale_factor error." if size[:w] % scale_factor > 0
      raise "height / scale_factor error." if size[:h] % scale_factor > 0
      scaled_sizes = {
         :w => size[:w] / scale_factor,
         :h => size[:h] / scale_factor
      }
      if tall_font
         raise "scaled_size H not divisible by 2" if scaled_sizes[:h] % 2 > 0
         scaled_sizes[:h] = scaled_sizes[:h] / 2
      end

      @size = scaled_sizes
      @scale = scale_factor

      # Create cell grid
      @grid = Array.new(@size[:h]) {Array.new(@size[:w]) {Cell.new}}

      font = Draw.new
      font.font_family = font_family
      font.gravity = CenterGravity
      @font = font
   end

   def setColors(pimg)
      pimg.scale!(pimg.columns, pimg.rows / 2) if @tall_font
      color_matrix = ColorReader::read(pimg)
      each_matrix_index(color_matrix) do |ri, ci|
         color = color_matrix[ri][ci]
         @grid[ri][ci].color = color
      end
   end
   
   def setString(string)
      total_cells = @grid.length * @grid[0].length
      if total_cells < string.length then
         puts "NOTICE: String on layer is longer than grid"
      elsif total_cells > string.length then
         raise "ERROR: String is shorter than grid"
      end

      each_matrix_index(@grid) do |ri, ci, p|
         count = p[:count]
         cell = p[:cell]
         
         cell.text = string[count]
      end
   end
end