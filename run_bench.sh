#! /usr/bin/env bash

./evmc/build/bin/evmc run --gas 100000000 --vm evmone/build/lib/libevmone.so $(cat build/f6m_mul_bench.bin)
