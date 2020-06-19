#! /usr/bin/env bash

set -e

./evmc/build/bin/evmc run --gas 100000000 --vm ./deps/v2/evmone/build/lib/libevmone.so $(cat $1)
