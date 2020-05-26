FROM ubuntu:20.04

RUN apt update && apt install -y git make python3

COPY solidity/build/solc/solc /usr/bin/solc
COPY evmc/build/bin/evmc /usr/bin/evmc
COPY evmone/build/lib/libevmone.so /root/libevmone.so
