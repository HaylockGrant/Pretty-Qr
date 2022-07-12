require 'perlin_noise'
require 'digest'

if ARGV[0] == nil
    puts "Usage: ruby noise.rb <seed> <optional length>"
    exit
end

length = 40
if(ARGV[1] == ARGV[1].to_i.to_s)
    length = ARGV[1].to_i
end
interval = 10.0
seed = Integer(Digest::MD5.hexdigest(ARGV[0]), 16)
n2d = Perlin::Noise.new(2, :seed => seed)
noise = []
for i in 0..length-1
    noise[i] = []
    o = (i+1)/(interval)
    for j in 0..length-1
        k = (j+1)/(interval)
        noise[i][j] = n2d[o,k]
        if(noise[i][j] > 0.50)
            print "x"
        else
            print " "
        end
    end
    puts
end
