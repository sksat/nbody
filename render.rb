#!/usr/bin/ruby

require 'parallel'

num = 0
nproc = `nproc`.to_i

puts "nproc: #{nproc}"

if ARGV.size() == 0
	num = `find out -type f -name "*.dat" | sort | tail -n1 | sed -e 's/[^0-9]//g'`.to_i
else
	num = ARGV[0].to_i
end

puts "num: #{num}"

Parallel.each([*0..num], progress: "rendering pov", in_processes: nproc) {|n|
	fname_base = "out/" + ("%010d" % n)
	pov = fname_base + ".pov"
	png = fname_base + ".png"
	if !File.exist?(pov)
		puts "pov file not found."+png
		exit -1
	elsif File.exist?(png)
		puts "png file exist: "+pov
	else
		ret = system("povray #{pov} 2> /dev/null")
		if ret != true
			puts "povray exec error(#{ret}): "+pov
			exit -1
		end
	end
}
print "done."
