require 'perlin_noise'
require 'digest'

if ARGV[0] == nil
    puts "Usage: ruby noise.rb <seed>"
    exit
end

length = 24
seed = Integer(Digest::MD5.hexdigest(ARGV[0]), 16)
n2d = Perlin::Noise.new(2, :seed => seed)
noise = []
for i in 0..length
    noise[i] = []
    o = i/(10.0)
    for j in 0..length
        k = j/(10.0)
        noise[i][j] = n2d[o,k]
        if(noise[i][j] > 0.50)
            print "x"
        else
            print " "
        end
    end
    puts
end
puts noise[0][0]
