all: clean build
build: build_dir v1 v2 v4 v3 v5 
build_dir:
	mkdir build

v3:
	./deps/v2/solidity/build/solc/solc --strict-assembly --optimize src/v3/benchmark.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v3-f6m_mul_bench.hex

v2:
	./deps/v2/solidity/build/solc/solc --strict-assembly --optimize src/v2/benchmark.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v2-f6m_mul_bench.hex
	./deps/v2/solidity/build/solc/solc --strict-assembly --optimize src/v2/test.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v2-test.hex
v4:
	./deps/v4/solidity/build/solc/solc --strict-assembly --optimize src/v4/benchmark.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v4-f6m_mul_bench.hex
	./deps/v4/solidity/build/solc/solc --strict-assembly --optimize src/v4/test.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v4-test.hex
v5:
	./deps/v4/solidity/build/solc/solc --strict-assembly --optimize src/v5/benchmark.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v5-f6m_mul_bench.hex
v1:
	./deps/v1/solidity/build/solc/solc --strict-assembly --optimize src/v1/benchmark.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v1-f6m_mul_bench.hex

benchmark:
	./benchmark.sh

circleci_build_image:
	docker build -t jwasinger/evm384 -f .circleci/Dockerfile .
clean:
	rm -rf build
