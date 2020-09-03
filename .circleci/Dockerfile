FROM ewasm/llvm-10:1

RUN apt update && apt install -y git make python3


# TODO only copy solc (and things that take too long to build in CI)

COPY deps/v2/solidity/build/solc/solc /root/project-deps/deps/v2/solidity/build/solc/solc
COPY deps/v2/evmone/build/lib/libevmone.so /root/project-deps/deps/v2/evmone/build/lib/libevmone.so 

COPY deps/v2-no-curve-params/solidity/build/solc/solc /root/project-deps/deps/v2-no-curve-params/solidity/build/solc/solc

COPY deps/v1/solidity/build/solc/solc /root/project-deps/deps/v1/solidity/build/solc/solc
COPY deps/v1/evmone/build/lib/libevmone.so /root/project-deps/deps/v1/evmone/build/lib/libevmone.so 

COPY deps/evmc/build/bin/evmc /usr/bin/evmc
