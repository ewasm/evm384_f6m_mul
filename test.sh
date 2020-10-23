set -e
PATH=deps/evmc/build/bin:$PATH

echo -e "\n\nrunning v2 test"
evmc run --gas 100000000 --vm deps/v2/evmone/build/lib/libevmone.so  $(cat build/v2-test.bin)

echo -e "\n\nrunning v2 bench"
evmc run --gas 100000000 --vm deps/v2/evmone/build/lib/libevmone.so  $(cat build/v2-f6m_mul_bench.bin)

echo -e "\n\nrunning v1 bench"
evmc run --gas 100000000 --vm deps/v1/evmone/build/lib/libevmone.so  $(cat build/v1-f6m_mul_bench.bin)
