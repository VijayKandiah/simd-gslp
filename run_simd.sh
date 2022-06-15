#!/bin/bash
root_dir=`pwd`
simd_dir=${root_dir}/Simd

if [ ! -d ${simd_dir} ] || [ ! -d ${simd_dir}/build_clang ] || [ ! -d ${simd_dir}/build_gslp ]; then
	echo "Please build the Simd Library benchmarks with ./build_simd.sh before running this script."
	exit
fi

cd ${simd_dir}/build_clang
# Took about 6m 43s on a Intel Xeon Gold 6258R
./Test -wt=1 -mt=100 -lc=1 -ot=clang.log 
tail -n +10 clang.log | head -n -1 | awk -F'|' '{print $2 $3}' | awk '{print $1 "," $3}' &> ${root_dir}/simd-clang.csv

cd ${simd_dir}/build_gslp
# Took about 6m 53s on a Intel Xeon Gold 6258R
./Test -wt=1 -mt=100 -lc=1 -ot=gslp.log 
tail -n +10 gslp.log | head -n -1 | awk -F'|' '{print $2 $3}' | awk '{print $1 "," $3}' &> ${root_dir}/simd-gslp.csv

#python3 get-simd-speedup.py ${root_dir}/simd-clang.csv ${root_dir}/simd-gslp.csv