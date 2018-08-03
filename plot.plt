if(exist("n")==0 || n<0) n=n0
frame = sprintf("out-%010d.dat", n)
cmd = sprintf("head -n1 %s", frame)
set xrange[-size/2:size/2]
set yrange[-size/2:size/2]
plot frame every ::2 u 2:3 w p title system(cmd)
n = n + dn
if(n < n1) reread
undefine n
