#!/bin/ruby

require 'parallel'

num = 0

if ARGV.size() == 0
	num = `ls out-*.dat | tail -n1 | sed -e 's/[^0-9]//g'`.to_i
else
	num = ARGV[0].to_i
end

Parallel.each([*0..num], progress: "converting dat->pov", in_processes: 4) {|n|
	fname_base = "out-" + ("%010d" % n)
	pov = fname_base + ".pov"
	png = fname_base + ".png"
	if !File.exist?(pov)
		puts "pov file not found."
		exit -1
	elsif File.exist?(png)
		puts "png file exist"
	else
		ret = system("povray #{pov}")
		if ret != 0
			puts "povray exec error"
			exit -1
		end
	end
}
print "done."
