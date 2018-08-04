set nokey
set term gif animate
set output "out.gif"
set size ratio 1
n0 = 0
n1 = "`find out -type f -name '*' | tail -n1 | sed -e 's/[^0-9]//g'`"
dn = @ARG1
size = @ARG2
load "plot.plt"
