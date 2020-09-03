#! /usr/bin/env bash

set -e

./deps/v1/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v1-f6m_mul_bench.bin 00 74229fc665e6c3f4401905c1a454ea57c8931739d05a074fd60400f19684d680a9e1305c25f13613dcc6cdd6e6e57d0800000000000000000000000000000000

./deps/v2/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v2-f6m_mul_bench.bin 00 74229fc665e6c3f4401905c1a454ea57c8931739d05a074fd60400f19684d680a9e1305c25f13613dcc6cdd6e6e57d0800000000000000000000000000000000

./deps/v2-no-curve-params/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v2-no-curve-params-f6m_mul_bench.bin 00 74229fc665e6c3f4401905c1a454ea57c8931739d05a074fd60400f19684d680a9e1305c25f13613dcc6cdd6e6e57d0800000000000000000000000000000000
