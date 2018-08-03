set nokey
set term gif animate
set output "out.gif"
set size ratio 1
n0 = 0
n1 = "`ls out-*.dat | tail -n1 | sed -e 's/[^0-9]//g'`"
dn = 1
load "plot.plt"
