#! /usr/bin/env bash
set -e

solc --strict-assembly --optimize src/f6m_mul/test.yul | awk '/Binary representation:/ { getline; print $0 }' > build/test.bin
evmc run --gas 100000000 --vm /root/libevmone.so $(cat build/test.bin) | python3 .circleci/catch_evmc_err.py
