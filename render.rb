#!/usr/bin/ruby
require 'parallel'

# ./render.rb OUTDIR width height
# ./render.rb OUTDIR width height num

num = 0
nproc = `nproc`.to_i

puts "nproc: #{nproc}"

if ARGV.size() == 3
	num = `find #{ARGV[0]} -type f -name "*.dat" | sort | tail -n1 | sed -e 's/[^0-9]//g'`.to_i
elsif ARGV.size() == 4
	num = ARGV[3].to_i
else
	puts "error"
	return -1
end

width = ARGV[1]
height = ARGV[2]

puts "num: #{num}"
puts "width: #{width}, height: #{height}"

Parallel.each([*0..num], progress: "rendering pov", in_processes: nproc) {|n|
	fname_base = "#{ARGV[0]}/" + ("%010d" % n)
	pov = fname_base + ".pov"
	png = fname_base + ".png"
	if !File.exist?(pov)
		puts "pov file not found."+png
		exit -1
	elsif File.exist?(png)
		puts "png file exist: "+pov
	else
		ret = system("povray +W#{width} +H#{height} #{pov} 2> /dev/null")
		if ret != true
			puts "povray exec error(#{ret}): "+pov
			exit -1
		end
	end
}
print "done."
