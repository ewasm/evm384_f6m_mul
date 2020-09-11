#! /usr/bin/env bash

set -e

./deps/v1/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v1-f6m_mul_bench.bin 00 74229fc665e6c3f4401905c1a454ea57c8931739d05a074fd60400f19684d680a9e1305c25f13613dcc6cdd6e6e57d0800000000000000000000000000000000 | python3 catch_evmone_bench_err.py

./deps/v2/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v2-f6m_mul_bench.bin 00 74229fc665e6c3f4401905c1a454ea57c8931739d05a074fd60400f19684d680a9e1305c25f13613dcc6cdd6e6e57d0800000000000000000000000000000000 | python3 catch_evmone_bench_err.py
./deps/v2-no-curve-params/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v2-no-curve-params-f6m_mul_bench.bin 00 74229fc665e6c3f4401905c1a454ea57c8931739d05a074fd60400f19684d680a9e1305c25f13613dcc6cdd6e6e57d0800000000000000000000000000000000 | python3 catch_evmone_bench_err.py

./deps/v3/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v3-f6m_mul_bench.bin 00 74229fc665e6c3f4401905c1a454ea57c8931739d05a074fd60400f19684d680a9e1305c25f13613dcc6cdd6e6e57d0800000000000000000000000000000000 | python3 catch_evmone_bench_err.py
# ./deps/v3-no-curve-params/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v3-no-curve-params-f6m_mul_bench.bin 00 74229fc665e6c3f4401905c1a454ea57c8931739d05a074fd60400f19684d680a9e1305c25f13613dcc6cdd6e6e57d0800000000000000000000000000000000 | python3 catch_evmone_bench_err.py

# incorrect result
./deps/v3-no-curve-params/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v3-no-curve-params-f6m_mul_bench.bin 00 3eb4cfbedd75a21a29701b4f4672232c52318353acdeef6d435d19a2681e023d153b8d400893da3b1525258aa820610e00000000000000000000000000000000 | python3 catch_evmone_bench_err.py

