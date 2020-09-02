#! /usr/bin/env bash

set -e

foobar=$(cat build/v2-f6m_mul_bench.bin)
./deps/evmc/build/bin/evmc run --gas 100000000 --vm ./deps/v2/evmone/build/lib/libevmone.so $foobar | python3 .circleci/catch_evmc_err.py
./deps/evmc/build/bin/evmc run --gas 100000000 --vm ./deps/v1/evmone/build/lib/libevmone.so $(cat build/v1-f6m_mul_bench.bin) | python3 .circleci/catch_evmc_err.py
./deps/evmc/build/bin/evmc run --gas 100000000 --vm ./deps/v2-no-curve-params/evmone/build/lib/libevmone.so $(cat build/v2-no-curve-params-f6m_mul_bench.bin) | python3 .circleci/catch_evmc_err.py
