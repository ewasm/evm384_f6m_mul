all:
	mkdir build && solidity/build/solc/solc --strict-assembly --optimize src/f6m_mul/benchmark.yul 2>&1 | awk '/Binary representation:/ { getline; print $0 }' > build/f6m_mul_bench.bin

clean:
	rm -rf build
