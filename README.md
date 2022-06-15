# Evaluating [GSLP](https://dl.acm.org/doi/pdf/10.1145/3519939.3523701) on [The Simd Library](https://ermig1979.github.io/Simd/)

Here are the steps to evaluate the performance of [GSLP](https://dl.acm.org/doi/pdf/10.1145/3519939.3523701) vectorizer against that of a production version of clang on 913 benchmarks from [The Simd Library](https://ermig1979.github.io/Simd/)

## Prerequisites

- `python 3.x.x`
- `cmake`
- A version of `clang`, preferably clang Version 12.0.1, included in your `$PATH`.
- The GSLP vectorizing compiler, `vegen-clang`, from [vegen pldi22-ae](https://github.com/ychen306/vegen/tree/pldi22-ae) included in your `$PATH`.


## To build SIMD library benchmarks with `clang` and `vegen-clang` auto-vectorizers:
From the root directory, run:
```bash
./build_simd.sh
```

## To run `clang` and `vegen-clang` auto-vectorized versions of SIMD library benchmarks:
From the root directory, run:
```bash
./run_simd.sh
```
This should create `simd-clang.csv` and `simd-gslp.csv` files in the root directory. Each CSV file contains the execution time (in ms) of 913 SIMD Library benchmarks.

## To get relative performance of GSLP over clang autovectorization
From the root directory, run:
```bash
python3 get-simd-speedup.py simd-clang.csv simd-gslp.csv
```
This should print out the relative performance of GSLP over clang for each of the 913 SIMD Library benchmarks along with the geomean relative performance.