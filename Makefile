all: clean build
build: build_dir v1 v2 v4 v3 v5 
build_dir:
	mkdir build

v3:
	./deps/v2/solidity/build/solc/solc --strict-assembly --optimize src/v3/benchmark.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v3-f6m_mul_bench.bin

v2:
	./deps/v2/solidity/build/solc/solc --strict-assembly --optimize src/v2/benchmark.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v2-f6m_mul_bench.bin
	./deps/v2/solidity/build/solc/solc --strict-assembly --optimize src/v2/test.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v2-test.bin
v4:
	./deps/v4/solidity/build/solc/solc --strict-assembly --optimize src/v4/benchmark.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v4-f6m_mul_bench.bin
	./deps/v4/solidity/build/solc/solc --strict-assembly --optimize src/v4/test.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v4-test.bin
v5:
	./deps/v4/solidity/build/solc/solc --strict-assembly --optimize src/v5/benchmark.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v5-f6m_mul_bench.bin
v1:
	./deps/v1/solidity/build/solc/solc --strict-assembly --optimize src/v1/benchmark.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v1-f6m_mul_bench.bin

benchmark:
	./benchmark.sh

circleci_build_image:
	docker build -t jwasinger/solc-evm384-v2 -f .circleci/Dockerfile .
clean:
	rm -rf build
