class ColorReader
   def self.read(img)
      pixels = Array.new(img.rows) { Array.new }
      img.each_pixel do |p, cc, rr|
         pixels[rr][cc] = p.to_color
      end

      return pixels
   end
end