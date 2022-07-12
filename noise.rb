require 'perlin_noise'
require 'digest'

if ARGV[0] == nil
    puts "Usage: ruby noise.rb <seed>"
    exit
end

length = 40
interval = 10.0
seed = Integer(Digest::MD5.hexdigest(ARGV[0]), 16)
n2d = Perlin::Noise.new(2, :seed => seed)
noise = []
for i in 0..length
    noise[i] = []
    o = i/(interval)
    for j in 0..length
        k = j/(interval)
        noise[i][j] = n2d[o,k]
        if(noise[i][j] > 0.50)
            print "x"
        else
            print " "
        end
    end
    puts
end