# ASCII Art
require 'RMagick'
include Magick
img = ImageList.new("static/naga.png").first
img = img.resize_to_fit(100, 100)
img = img.scale(120, 90)
f_out = File.new("mod.txt", "w")
char_set = ".:oO8@"
thresh = {}
pixels = img.get_pixels(0,0,img.columns,img.rows)
vals = pixels.map{|px| px.red + px.green + px.blue}.sort
char_set.reverse.each_char.with_index{|c, i|
    thresh[c] = 0.00017 * vals.inject(:+) * (i.to_f/char_set.size)
}
thresh = Hash[ thresh.sort_by { |key, val| -val } ]
pixels.each_with_index{|px, i|
    row_num = i / img.columns
    col_num = i % img.columns
    if col_num == 0
        f_out.write("\n")
    end
    cols = [px.red, px.blue, px.green]
    grey = cols.reduce(:+)
    thresh.each_pair{|char, val|
        if grey >= val
            f_out.write(char)
            break
        end
    }
}
f_out.close