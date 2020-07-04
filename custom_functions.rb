def each_matrix_index(matrix, &block)
   props = {
      :row_max => matrix.length - 1,
      :col_max => matrix[0].length - 1,
      :total_cells => matrix.length * matrix[0].length,
      :count => -1,
      :cell => nil
   }
   
   matrix.each_index do |ri|
      matrix[ri].each_index do |ci|
         props[:count] = props[:count] + 1
         props[:cell] = matrix[ri][ci]
         yield(ri, ci, props)
      end
   end

end

def matrix_area(matrix, px, py, sx, sy, center: false, &block)
   startx = 0
   starty = 0
   if center
      startx = (matrix[0].length / 2).to_i
      if sx > 1
         startx -= (sx / 2).to_i
      end

      starty = (matrix.length / 2).to_i
      if sy > 1
         starty -= (sy / 2).to_i
      end
   end
   x = startx + px
   y = starty + py
   lx = x + sx - 1
   ly = y + sy - 1

   # First, get rows
   area = matrix[y..ly]
   # Now, clean columns
   area.each_index do |i|
      area[i] = area[i][x..lx]
   end

   # we iterare on it
   each_matrix_index(area, &block)
end

def random_ascii
   return rand(32..126).chr
end