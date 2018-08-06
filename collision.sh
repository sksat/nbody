#!/bin/sh
num=5000

rm *.dat
./mk_plummer -n $num > plummer-$num.dat
./util.rb slide plummer-$num.dat  10.0  0.0  0.0 -1.0  0.0  0.0
mv plummer-$num-slide.dat plummer-$num-one.dat
./util.rb slide plummer-$num.dat -10.0  0.0  0.0  1.0  0.0  0.0
./util.rb merge plummer-$num-one.dat plummer-$num-slide.dat
mv merged.dat plummer-collision-$num.dat
