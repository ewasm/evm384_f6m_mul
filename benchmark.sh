#! /usr/bin/env bash

set -e

./deps/v1/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v1-f6m_mul_bench.bin 00 74229fc665e6c3f4401905c1a454ea57c8931739d05a074fd60400f19684d680a9e1305c25f13613dcc6cdd6e6e57d0800000000000000000000000000000000 | python3 catch_evmone_bench_err.py

./deps/v2/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v2-f6m_mul_bench.bin 00 74229fc665e6c3f4401905c1a454ea57c8931739d05a074fd60400f19684d680a9e1305c25f13613dcc6cdd6e6e57d0800000000000000000000000000000000 | python3 catch_evmone_bench_err.py
./deps/v2-no-curve-params/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v2-no-curve-params-f6m_mul_bench.bin 00 74229fc665e6c3f4401905c1a454ea57c8931739d05a074fd60400f19684d680a9e1305c25f13613dcc6cdd6e6e57d0800000000000000000000000000000000 | python3 catch_evmone_bench_err.py

./deps/v3/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v3-f6m_mul_bench.bin 00 74229fc665e6c3f4401905c1a454ea57c8931739d05a074fd60400f19684d680a9e1305c25f13613dcc6cdd6e6e57d0800000000000000000000000000000000 | python3 catch_evmone_bench_err.py
./deps/v3-no-curve-params/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v3-no-curve-params-f6m_mul_bench.bin 00 74229fc665e6c3f4401905c1a454ea57c8931739d05a074fd60400f19684d680a9e1305c25f13613dcc6cdd6e6e57d0800000000000000000000000000000000 | python3 catch_evmone_bench_err.py
./deps/v3-no-curve-params/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v3-no-curve-params-f2m_mul_bench.bin 00 aff6e01e71b0709e0f7f6528dd81ea41aed732761d712e6884576a7b04a9490e64be863464e7b928ab4a709d2e2e7b0e00000000000000000000000000000000bb65fcee5ae7b04cef799771e1fd0e597838d8088633a9f99a3e9c62d4d48989b3ef3e3451ad30b40dedb7b6f928ae1400000000000000000000000000000000 | python3 catch_evmone_bench_err.py

# test yul f2m_mul loop
./deps/v2/evmone/build/bin/evmone-bench --benchmark_format=json --benchmark_color=false --benchmark_min_time=5 build/v2-f2m_mul_bench.bin 00 aff6e01e71b0709e0f7f6528dd81ea41aed732761d712e6884576a7b04a9490e64be863464e7b928ab4a709d2e2e7b0e00000000000000000000000000000000bb65fcee5ae7b04cef799771e1fd0e597838d8088633a9f99a3e9c62d4d48989b3ef3e3451ad30b40dedb7b6f928ae1400000000000000000000000000000000 | python3 catch_evmone_bench_err.py
