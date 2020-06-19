FROM ubuntu:20.04

RUN apt update && apt install -y git make python3

COPY deps/v2/solidity/build/solc/solc /usr/bin/solc-v2
COPY deps/v2/evmone/build/lib/libevmone.so /root/libevmone-v2.so
COPY deps/v1/solidity/build/solc/solc /usr/bin/solc-v1
COPY deps/v1/evmone/build/lib/libevmone.so /root/libevmone-v1.so

COPY deps/evmc/build/bin/evmc /usr/bin/evmc
