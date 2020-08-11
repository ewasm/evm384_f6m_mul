#pragma once

#include "intx/intx.hpp"
#include "intx/int128.hpp"

// Mask128 = 0xffffffffffffffffffffffffffffffff
intx::uint128 Mask128 = intx::from_string<intx::uint128>("340282366920938463463374607431768211455");

//0xffffffffffffffff
intx::uint128 Mask64 = intx::from_string<intx::uint128>("18446744073709551615");

// for bls12-381

typedef unsigned __int128 uint128_t;


// Mask192 = 0xffffffffffffffffffffffffffffffffffffffffffffffff
intx::uint256 Mask192 = intx::from_string<intx::uint256>("6277101735386680763835789423207666416102355444464034512895");
// field modulus = 0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab
intx::uint512 BignumModulus512 = intx::from_string<intx::uint512>("4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559787");
intx::uint512 BignumModulus = BignumModulus512;
intx::uint256 BignumInv64 = intx::from_string<intx::uint256>("9940570264628428797");

// TODO get rid of these
uint64_t* BignumModulusPointer = reinterpret_cast<uint64_t*>(&BignumModulus512);
uint64_t* BignumInvPointer = reinterpret_cast<uint64_t*>(&BignumInv64);

// TODO use two uint384s
// typedef intx::uint512 F1;

struct F1 {
    intx::uint512 elem;

    std::string to_string();
    bool Eq(F1 &other);
    F1 Add(F1 &other);
    F1 Sub(F1 &other);
    F1 Mul(F1 &other);

    F1();
    F1(intx::uint512 val);
};

struct F2 {
    F1 x;
    F1 y;

    std::string to_string();
    bool Eq(F2 &other);
    F2 Add(F2 &other);
    F2 Mul(F2 &other);
    F2 Sub(F2 &other);
    F2 MulNR();
};

struct F6 {
    F2 a;
    F2 b;
    F2 c;

    std::string to_string();
    bool Eq(F6 &other);
    F6 Mul(F6 &other);
};
