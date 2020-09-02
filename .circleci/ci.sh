#! /usr/bin/env bash
set -e

# TODO can I sym-link these for the script ?

mkdir -p /root/project/deps/evmc/build/bin

mkdir -p /root/project/deps/v2/evmone/build/lib
mkdir -p /root/project/deps/v1/evmone/build/lib
mkdir -p /root/project/deps/v2-no-curve-params/evmone/build/lib

mkdir -p /root/project/deps/v2/solidity/build/solc
mkdir -p /root/project/deps/v1/solidity/build/solc
mkdir -p /root/project/deps/v2-no-curve-params/solidity/build/solc

cp /root/project-deps/deps/v2/evmone/build/lib/libevmone.so /root/project/deps/v2/evmone/build/lib/libevmone.so
cp /root/project-deps/deps/v1/evmone/build/lib/libevmone.so /root/project/deps/v1/evmone/build/lib/libevmone.so
cp /root/project-deps/deps/v2-no-curve-params/evmone/build/lib/libevmone.so /root/project/deps/v2-no-curve-params/evmone/build/lib/libevmone.so

cp /root/project-deps/deps/v2/solidity/build/solc/solc /root/project/deps/v2/solidity/build/solc/solc
cp /root/project-deps/deps/v2-no-curve-params/solidity/build/solc/solc /root/project/deps/v2-no-curve-params/solidity/build/solc/solc
cp /root/project-deps/deps/v1/solidity/build/solc/solc /root/project/deps/v1/solidity/build/solc/solc

cp $(which evmc) /root/project/deps/evmc/build/bin/evmc

make all

make benchmark
