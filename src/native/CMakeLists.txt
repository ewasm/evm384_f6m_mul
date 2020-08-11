cmake_minimum_required (VERSION 3.0)
project (f6m_mul_native)

include_directories(./intx/include)

add_executable(test f6m_mul.h test.cpp)
add_executable(synth_loop_benchmark f6m_mul.h benchmark.cpp)
