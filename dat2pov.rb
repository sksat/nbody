#!/bin/ruby
require 'parallel'

def dat2pov(fname)
	begin
		num = 0
		time = 0.0
		lines = []
		pos = []
		vel = []
		file = File.open(fname, "r"){|f|
			num = f.gets.to_i
			time = f.gets.to_f
			lines = f.readlines
		}
		fname = fname.gsub(/dat/, "pov")
		pov = File.open(fname, "w")
		pov.puts("#include \"common.inc\"")
		pov.puts("LIGHT_SRC(<10.0,0.0,0.0>, <0.0,0.0,0.0>)")
		pov.puts("CAM(<10.0,0.0,0.0>, <0.0,0.0,0.0>, 45)")
		for l in lines do
			dat = l.split
			mass= dat[0]
			pos[0] = dat[1]
			pos[1] = dat[2]
			pos[2] = dat[3]
			l = "SP(" + ("<#{pos[0]},#{pos[1]},#{pos[2]}>") + ",0.01)"
			pov.puts(l)
		end
	rescue => error
		print error
		exit -1
	end
end

if ARGV.size() == 0 then
	num = `ls out-*.dat | tail -n1 | sed -e 's/[^0-9]//g'`.to_i
	Parallel.each([*0..num], progress: "converting dat->pov", in_processes: 4) {|n|
		fname = "out-" + ("%010d" % n) + ".dat"
		dat2pov fname
	}
	print "done."
else
	dat2pov ARGV[0]
end
