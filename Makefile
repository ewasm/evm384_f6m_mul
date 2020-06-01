all: clean build
build: build_dir v1 v2
build_dir:
	mkdir build

v2:
	./deps/v2/solidity/build/solc/solc --strict-assembly --optimize src/v2/benchmark.yul 2>&1 | awk '/Binary representation:/ { getline; print $0 }' > build/v2-f6m_mul_bench.bin
	./deps/v2/solidity/build/solc/solc --strict-assembly --optimize src/v2/test.yul 2>&1 | awk '/Binary representation:/ { getline; print $0 }' > build/v2-test.bin
v1:
	./deps/v1/solidity/build/solc/solc --strict-assembly --optimize src/v1/benchmark.yul 2>&1 | awk '/Binary representation:/ { getline; print $0 }' > build/v1-f6m_mul_bench.bin

# TODO: v1 test case and fix this Makefile so that solidity causes the build to end when it finds errors

circleci_build_image:
	docker build -t jwasinger/solc-evm384-v2 -f .circleci/Dockerfile .
clean:
	rm -rf build
