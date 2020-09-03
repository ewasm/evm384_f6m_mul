#! /usr/bin/env bash
set -e

cd /root/project && git submodule update --init --recursive

(cd /root/project/deps/v2-no-curve-params/evmone && \
	mkdir build && \
	cd build && cmake -DEVMONE_TESTING=ON .. && make -j4)

(cd /root/project/deps/v2/evmone && \
	mkdir build && \
	cd build && cmake -DEVMONE_TESTING=ON .. && make -j4)

(cd /root/project/deps/v1/evmone && \
	mkdir build && \
	cd build && cmake -DEVMONE_TESTING=ON .. && make -j4)

mkdir -p /root/project/deps/v2-no-curve-params/solidity/build/solc
mkdir -p /root/project/deps/v2/solidity/build/solc
mkdir -p /root/project/deps/v1/solidity/build/solc

cp /root/project-deps/deps/v2/solidity/build/solc/solc /root/project/deps/v2/solidity/build/solc/solc
cp /root/project-deps/deps/v2-no-curve-params/solidity/build/solc/solc /root/project/deps/v2-no-curve-params/solidity/build/solc/solc
cp /root/project-deps/deps/v1/solidity/build/solc/solc /root/project/deps/v1/solidity/build/solc/solc

mkdir -p /root/project/deps/evmc/build/bin
cp $(which evmc) /root/project/deps/evmc/build/bin/evmc

make all

make benchmark
