#! /usr/bin/env bash

set -e

./deps/v6/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v6-f6m_mul_bench.hex 00 ff | python3 catch_evmone_bench_err.py
./deps/v7/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v7-f6m_mul_bench.hex "" "" | python3 catch_evmone_bench_err.py
