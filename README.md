# EVM384

Implementations and benchmarks for cryptographic primitives in an EVM augmented to support 384 bit modular arithmetic.

Currently the only example/benchmark is multiplication of two "F6" points, elements of an extension field used implementations of BLS12-381 pairing ([example](https://github.com/iden3/wasmsnark/tree/master/src/bls12381))

## Usage

### Build dependencies:
```
git submodule update --init --recursive
(cd evmone && mkdir build && cd build && cmake .. && make -j4)
(cd evmc && mkdir build && cd build && cmake -DEVMC_TOOLS=ON .. && make -j4)
(cd solidity && mkdir build && cd build && cmake .. && make -j4)
```

### Build and benchmark `f6m_mul`:
`python3 benchmark.py`
