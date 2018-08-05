#!/usr/bin/ruby

# ./util.rb slide hoge.dat (ask dx,dy,dz
# ./util.rb slide hoge.dat <dx> <dy> <dz>
# ./util.rb merge hoge.dat fuga.dat

def slide(fname, d_vec)
	num = 0
	time = 0.0
	lines = []
	org = File.open(fname, "r"){|f|
		num = f.gets.to_i
		time = f.gets.to_f
		lines = f.readlines
	}
	fname = fname.gsub(/.dat/, "")
	fname += "-slide.dat"
	file = File.open(fname, "w")

	file.puts(num)
	file.puts(time)

	for l in lines do
		dat = l.split
		mass = dat[0]
		pos = []
		vec = []
		pos[0] = dat[1] + d_vec[0]
		pos[1] = dat[2] + d_vec[1]
		pos[2] = dat[3] + d_vec[2]
		vec[0] = dat[4]
		vec[1] = dat[5]
		vec[2] = dat[6]
		l = "#{mass} #{pos[0]} #{pos[1]} #{pos[2]} #{vec[0]} #{vec[1]} #{vec[2]}"

		file.puts(l)
	end
end

def merge(fname1, fname2)
	num = []
	time= []
	lines1 = []
	lines2 = []
	file1 = File.open(fname1, "r"){|f|
		num[0]	= f.gets.to_i
		time[0]	= f.gets.to_f
		lines1	= f.readlines
	}
	file2 = File.open(fname2, "r"){|f|
		num[1]	= f.gets.to_i
		time[1]	= f.gets.to_f
		lines2	= f.readlines
	}
	if time[0] != time[1]
		puts "error"
		exit -1
	end
	dist = File.open("merged.dat", "w"){|f|
		n = num[0] + num[1]
		t = time[0]
		f.puts(n)
		f.puts(t)
		for l in lines1 do
			f.puts(l)
		end
		for l in lines2 do
			f.puts(l)
		end
	}
end

if ARGV.size() == 0
	puts "1: slide"
	puts "2: merge"
elsif ARGV[0] == "slide"
	if ARGV.size() == 5
		slide(ARGV[1], [ARGV[2],ARGV[3],ARGV[4]])
	end
elsif ARGV[0] == "merge"
	if ARGV.size() == 3
		merge(ARGV[1], ARGV[2])
	end
end
