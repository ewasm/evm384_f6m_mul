cmake_minimum_required (VERSION 3.0)
project (f6m_mul_native)

include_directories(./intx/include)

add_executable(f6m_mul_test f6m_mul.h test.cpp)
add_executable(f6m_mul_benchmark f6m_mul.h benchmark.cpp)
