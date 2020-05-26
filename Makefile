all: clean build
build:
	mkdir build && solidity/build/solc/solc --strict-assembly --optimize src/f6m_mul/benchmark.yul 1>&2 | awk '/Binary representation:/ { getline; print $0 }' > build/f6m_mul_bench.bin
	solidity/build/solc/solc --strict-assembly --optimize src/f6m_mul/test.yul 2>&1 | awk '/Binary representation:/ { getline; print $0 }' > build/test.bin

circleci_build_image:
	docker build -t jwasinger/solc-evm384-v2 -f .circleci/Dockerfile .
clean:
	rm -rf build
