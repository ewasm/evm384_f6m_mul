all: clean build
build: build_dir v1 v2 v2_no_curve_params
build_dir:
	mkdir build

v2:
	./deps/v2/solidity/build/solc/solc --strict-assembly --optimize src/v2/benchmark.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v2-f6m_mul_bench.bin
	./deps/v2/solidity/build/solc/solc --strict-assembly --optimize src/v2/test.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v2-test.bin
v2_no_curve_params:
	./deps/v2-no-curve-params/solidity/build/solc/solc --strict-assembly --optimize src/v2-no-curve-params/benchmark.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v2-no-curve-params-f6m_mul_bench.bin
	./deps/v2-no-curve-params/solidity/build/solc/solc --strict-assembly --optimize src/v2-no-curve-params/test.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v2-no-curve-params-test.bin
v1:
	./deps/v1/solidity/build/solc/solc --strict-assembly --optimize src/v1/benchmark.yul | awk '/Binary representation:/ { getline; print $0 }' | grep . > build/v1-f6m_mul_bench.bin

benchmark:
	./benchmark.sh

circleci_build_image:
	docker build -t jwasinger/solc-evm384-v2 -f .circleci/Dockerfile .
clean:
	rm -rf build
