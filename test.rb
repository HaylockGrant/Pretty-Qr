require 'httparty'
require 'json'
require 'rqrcode'
require 'chunky_png'

#This class represents the color of the corner and allows other classes to referance and access it wihtout having duplicates.
class Corner
    attr_accessor :color
    def initialize(color)
        @color = color
    end

    def initialize()
        @color = nil;
    end
end

class Cell
    attr_accessor :color , :ulCorner, :urCorner, :llCorner, :lrCorner
    def initialize(color)
        @color = color
        @ulCorner = nil
        @urCorner = nil
        @llCorner = nil
        @lrCorner = nil
    end

    def getUL()
        if @ulCorner == nil
            return @color
        else
            return @ulCorner
        end
    end

    def getUR()
        if @urCorner == nil
            return @color
        else
            return @urCorner
        end
    end

    def getLL()
        if @llCorner == nil
            return @color
        else
            return @llCorner
        end
    end

    def getLR()
        if @lrCorner == nil
            return @color
        else
            return @lrCorner
        end
    end

    def getColor()
        return @color
    end
end

#Class CornerCross represents all the 4 corners of a 4 cell cross
class Cross
    attr_accessor :ul, :ur, :ll, :lr
    def initialize(ul, ur, ll, lr)
        @ul = ul
        @ur = ur
        @ll = ll
        @lr = lr
    end

    #The following 4 methods are used to get the cell in the corosponding corner of the cross
    def getULCell()
        return @ul
    end

    def getURCell()
        return @ur
    end

    def getLLCell()
        return @ll
    end

    def getLRCell()
        return @lr
    end

    #The following 4 methods are used to get the corner that is touching the cross

    def getULCorner()
        return @ul.getLR()
    end

    def getURCorner()
        return @ur.getLL()
    end

    def getLLCorner()
        return @ll.getUR()
    end

    def getLRCorner()
        return @lr.getUL()
    end
end


#this function takes a string and turns it into a double array of characters
def s_to_array(string)
    array = string.split("\n")
    for i in 0..array.length-1
        array[i] = array[i].split("")
    end
    return array
end

#Function print_arrays prints the arrays of characters
def print_arrays(array)
    array.each do |row|
        row.each do |column|
            print column
        end
        puts
    end
end

#returns the locations of a patern in a 2d array
=begin
The array will be iterated by row then column searching for the beggining of the pattern
once the start is found it will check the surroundings cells for each piece of the pattern
=end
def find_pattern(pattern, array)
    locations = []
    row_size = pattern.length
    column_size = pattern[0].length
    if(row_size > array.length || column_size > array[0].length)
        puts 'Pattern is too large for the array'
        return locations
    end
    for i in 0..array.length-row_size
        for j in 0..array[i].length-column_size
            if(array[i][j] == pattern[0][0])
                match = true
                for x in 0..pattern.length-1
                    for y in 0..pattern[x].length-1
                        if(array[i+x][j+y] != pattern[x][y])
                            match = false
                            break
                        end
                    end
                    if match == false
                        break
                    end
                end
                if match 
                    locations.push([i,j])
                end
            end
        end
    end
    return locations
end


#This function will calculate the locations of the individual pieces of the pattern given the locations of the pattern
def find_pattern_pieces(initial_location, pattern)
    locations = []
    for i in 0..pattern.length-1
        for j in 0..pattern[i].length-1
            if(pattern[i][j] == 'x')
                locations.push([initial_location[0]+i,initial_location[1]+j])
            end
        end
    end
end

#takes in ARGV[0] and checks to see if its nil
if ARGV[0] == nil
  puts "Usage: ruby test.rb <url>"
  exit
end

#initilize url as argv[0]
url = ARGV[0]
path = 'qr.png'

#creates a qr code object with the url
qr = RQRCode::QRCode.new(url, :level => :h)

#creates a png file with the qr code
qr.as_png(:margin => 0).save("#{path}", :quality => 100)

#splits the string into an arrays of strings by the new line character
text = qr.to_s()
qr_array = text.split("\n")

#iterates through array
for i in 0..qr_array.length-1
  #splits each line into an array of characters
  qr_array[i] = qr_array[i].split("")
    #iterates through each character in the line
    for j in 0..qr_array[i].length-1
        #if the character is a space
        if qr_array[i][j] == " "
            #replace it with a _
            qr_array[i][j] = "_"
        end
    end
end

#prints the qr code
#print_arrays(qr_array)

#initialize the eye patterns
corner_patern = "xxxxxxx\nx_____x\nx_xxx_x\nx_xxx_x\nx_xxx_x\nx_____x\nxxxxxxx"
corner_patern = s_to_array(corner_patern)
small_eye_pattern = "xxxxx\nx___x\nx_x_x\nx___x\nxxxxx"
small_eye_pattern = s_to_array(small_eye_pattern)

#copilot generated patern of what it thinks a lage eye pattern is, it serves no purpose, but I think its neat so I'm going to keep it
large_eye_pattern = "xxxxxxx\nx_____x\nx_xxxxx\nx_____x\nxxxxxxx"
large_eye_pattern = s_to_array(large_eye_pattern)
#print_arrays(large_eye_pattern)

#initialize the patterns for the eyes
corner_locations = []
small_eye_locations = []

#finds the locations of the corner paterns and small eye paterns
corner_locations = find_pattern(corner_patern, qr_array)
small_eye_locations = find_pattern(small_eye_pattern, qr_array)

#initialize the 2d array of cells with their base black and white colors
cells = Array.new(qr_array.length) { Array.new(qr_array[0].length) }
for i in 0..qr_array.length-1
    for j in 0..qr_array[i].length-1
        case qr_array[i][j]
        when '_' #white
            cells[i][j] = (Cell.new(ChunkyPNG::Color::rgb(255, 255, 255)))
        when 'x' #black
            cells[i][j] = (Cell.new(ChunkyPNG::Color::rgb(0, 0, 0)))
        when 'c' #corner
            cells[i][j] = (Cell.new(ChunkyPNG::Color::rgb(133, 58, 67)))
        when 'e' #eye
            cells[i][j] = (Cell.new(ChunkyPNG::Color::rgb(133, 58, 67)))
        end
    end
end

#Test commit