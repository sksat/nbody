set nokey
set term gif animate
set output "out.gif"
set size ratio 1
n = 0
n1 = system("find ".ARG1." -type f -name '*.dat' | sort | tail -n1 | sed -e 's/[^0-9]//g'")
dn = @ARG2
size = @ARG3

set xrange[-size*0.5:size*0.5]
set yrange[-size*0.5:size*0.5]
set zrange[-size*0.5:size*0.5]

while(n<=n1) {
	frame = sprintf("%s/%010d.dat", ARG1, n)
	plot frame every ::2 u 2:3 w p
	n = n + dn
}
