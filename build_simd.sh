#!/bin/bash
root_dir=`pwd`
simd_dir=${root_dir}/Simd

if ! command -v clang &> /dev/null ; then
	echo "Please install a version of \"clang\" and include it in your \$PATH variable before running this script."
	exit
fi

if ! command -v vegen-clang &> /dev/null ; then
	echo "Please install \"vegen-clang\" and include it in your \$PATH variable before running this script."
	exit
fi

if [ -d ${simd_dir} ] ; then
	rm -r ${simd_dir}
fi

git clone https://github.com/ermig1979/Simd
cd ${simd_dir}
git checkout tags/v4.10.114
#Disabling hand-written intrinsic based versions to significantly improve compilation time
awk -i inplace 'NR==4 {$0="\tset(COMMON_CXX_FLAGS \"${COMMON_CXX_FLAGS} -m64 -DSIMD_SSE2_DISABLE -DSIMD_AVX_DISABLE -DSIMD_AVX2_DISABLE -DSIMD_AVX512F_DISABLE -DSIMD_AVX512BW_DISABLE\")"} 1' prj/cmake/x86.cmake 
#Adding "-march=native -O3 -ffast-math" to compiler flags list for both clang and vegen-clang
awk -i inplace 'NR==8 {$0="set_source_files_properties(${SIMD_BASE_SRC} PROPERTIES COMPILE_FLAGS \"${COMMON_CXX_FLAGS} -march=native -O3 -ffast-math\")"} 1' prj/cmake/x86.cmake

mkdir ${simd_dir}/build_clang
cd ${simd_dir}/build_clang
cmake ../prj/cmake -DSIMD_TOOLCHAIN="clang" -DSIMD_TARGET=""
#took ~10 seconds to complete on a Intel Xeon Gold 6258R with 112 logical cores
make -j 

mkdir ${simd_dir}/build_gslp
cd ${simd_dir}/build_gslp
cmake ../prj/cmake -DSIMD_TOOLCHAIN="vegen-clang" -DSIMD_TARGET=""
#took ~12 minutes to complete a Intel Xeon Gold 6258R with 112 logical cores
make -j 