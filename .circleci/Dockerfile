FROM ewasm/llvm-10:1

RUN apt update && apt install -y git make python3

COPY deps/v2/solidity/build/solc/solc /root/project-deps/deps/v2/solidity/build/solc/solc
# COPY deps/v2/evmone/build/lib/libevmone.so /root/project-deps/deps/v2/evmone/build/lib/libevmone.so 

COPY deps/v4/solidity/build/solc/solc /root/project-deps/deps/v4/solidity/build/solc/solc

COPY deps/v1/solidity/build/solc/solc /root/project-deps/deps/v1/solidity/build/solc/solc
# COPY deps/v1/evmone/build/lib/libevmone.so /root/project-deps/deps/v1/evmone/build/lib/libevmone.so 

# COPY deps/evmc/build/bin/evmc /usr/bin/evmc
