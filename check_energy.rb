#!/usr/bin/ruby

def check_energy(fname)
	begin
		e = 0.0
		file = File.open(fname, "r"){|f|
			num = f.gets.to_i
			time= f.gets.to_f
			lines=f.readlines
			for l in lines do
				pos = []
				vec = []
				dat = l.split
				mass= dat[0].to_f
				pos[0] = dat[1].to_f
				pos[1] = dat[2].to_f
				pos[2] = dat[3].to_f
				vec[0] = dat[4].to_f
				vec[1] = dat[5].to_f
				vec[2] = dat[6].to_f
				v = Math.sqrt(vec[0]*vec[0] + vec[1]*vec[1] + vec[2]*vec[2])
				e += 0.5 * mass * (v*v)
			end
		}
		puts "#{e}"
	rescue => error
		print error
	end
end

if ARGV.size() == 1 then
	if File.file?(ARGV[0])
		check_energy(ARGV[0])
	elsif File.directory?(ARGV[0])
		files = Dir.entries(ARGV[0])
		num = 0
		for f in files
			if f != "." && f != ".." && f.include?(".dat")
				print "#{num} "
				check_energy(ARGV[0]+"/"+f)
				num = num+1
			end
		end
	end
else
	puts "error"
end
