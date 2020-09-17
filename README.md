# EVM384

Implementations and benchmarks for cryptographic primitives in an EVM augmented to support 384 bit modular arithmetic.

Currently the only example/benchmark is multiplication of two "F6" points, elements of an extension field used implementations of BLS12-381 pairing ([example](https://github.com/iden3/wasmsnark/tree/master/src/bls12381))

## Usage

### Benchmark latest V6/V7 implementations using evmone-bench

```
git submodule update --init --recursive
(cd deps/v6/evmone && mkdir build && cd build && cmake -DEVMONE_TESTING=ON .. && make -j4)
(cd deps/v7/evmone && mkdir build && cd build && cmake -DEVMONE_TESTING=ON .. && make -j4)
make benchmark
```
