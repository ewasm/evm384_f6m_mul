/*
This is a direct translation of: https://github.com/ewasm/evm384_f6m_mul/blob/master/src/v2/test.yul

To execute:
git clone https://github.com/poemm/bigint_experiments.git
cd bigint_experiments
git clone https://gist.github.com/4ad8279ea1693c13a16b134970d67101.git f6m_mul_gist
cd f6m_mul_gist
gcc f6m_mul.c -o f6m_mul -O4 -march=native
./f6m_mul
*/


#include<stdio.h>
#include<iostream>
#include<iomanip>

#include "f6m_mul.h"

F1::F1() {
    //TODO static element for zero?
    this->elem = intx::from_string<intx::uint512>("0");
}

F1::F1(intx::uint512 val) {
    this->elem = val;
}

std::string F1::to_string() {
    std::stringstream ss;

    ss << std::hex;
    for (size_t i = 0; i < 48; i++) {
        ss << std::setw(2) << std::setfill('0') << static_cast<int>(*((uint8_t *)&this->elem + i));
    }

    return ss.str();
}

std::string F2::to_string() {
    std::stringstream ss;

    ss << "x: " << this->x.to_string() << ",\ny: " << this->y.to_string() << "\n";
    return ss.str();
}

inline uint8_t less_than_or_equal384_64bitlimbs(const uint64_t* const x, const uint64_t* const y){
  for (int i=(384/64)-1;i>=0;i--){
    if (x[i]>y[i])
      return 0;
    else if (x[i]<y[i])
      return 1;
  }

  return 1;
}

inline void subtract384_64bitlimbs(uint64_t* const out, const uint64_t* const x, const uint64_t* const y){
 //uint64_t carrySubGlobal=0;
 uint64_t carry=0;

#pragma unroll
  for (int i=0; i<(384/64);i++){

    // out_temp in case x or y is out
    uint64_t out_temp = x[i]-y[i]-carry;
    carry = (x[i]<y[i] || y[i]<carry) ? 1:0;
    out[i] = out_temp;


    /*
    uint64_t temp = x[i]-carry;
    out[i] = temp-y[i];
    carry = (temp<y[i] || x[i]<carry) ? 1:0;
    */
  }
}

// montmul384_64bitlimbs
inline void montgomery_multiplication_384(const uint64_t* const x, const uint64_t* const y, const uint64_t* const m, const uint64_t* const inv, uint64_t* const out){
  //const auto start_time = chrono_clock::now();

  //using __uint128_t = interp::uint128_t;
  // (384/64)*2+1 = 13
  uint64_t A[(384/64)*2+1];
  for (int i=0;i<(384/64)*2+1;i++)
    A[i]=0;

  for (int i=0; i<(384/64); i++){
    uint64_t ui = (A[i]+x[i]*y[0])*inv[0];
    uint64_t carry = 0;
#pragma unroll
    for (int j=0; j<(384/64); j++){
      uint128_t xiyj = (uint128_t)x[i]*y[j];
      uint128_t uimj = (uint128_t)ui*m[j];
      uint128_t partial_sum = xiyj+carry+A[i+j];
      uint128_t sum = uimj+partial_sum;
      A[i+j] = (uint64_t)sum;
      carry = sum>>64;

      if (sum<partial_sum){
        int k=2;
        while ( i+j+k<(384/64)*2 && A[i+j+k]==(uint64_t)0-1 ){
          A[i+j+k]=0;
          k++;
        }
        if (i+j+k<(384/64)*2+1)
          A[i+j+k]+=1;
      }

    }
    A[i+(384/64)]+=carry;
  }



  for (int i=0; i<(384/64);i++)
    out[i] = A[i+(384/64)];


  if (A[(384/64)*2]>0 || less_than_or_equal384_64bitlimbs(m,out))
    subtract384_64bitlimbs(out, out, m);

  //const auto end_time = chrono_clock::now();
  //std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time)
  //std::chrono::microseconds one_loop = (end_time - start_time);
  //montmul_duration = montmul_duration + std::chrono::duration_cast<std::chrono::nanoseconds>(end_time - start_time);
}

inline void addmod384_64bitlimbs(uint64_t* out, uint64_t* x, uint64_t* y,  uint64_t* mod){
  uint64_t carry=0;
  uint64_t temp=0;
  //carryAddGlobal[0] = 0;

#pragma unroll
  for (int i=0; i<(384/64);i++){
    temp = x[i]+y[i]+carry;
    carry = x[i] > temp ? 1:0;
    out[i]=temp;
  }

#pragma unroll
  for (int i=(384/64)-1;i>=0;i--){
    if (out[i]>mod[i]) {

      // begin subtraction
      //uint64_t subcarry1=0;
      carry = 0;
    #pragma unroll
      for (int i=0; i<(384/64);i++){
        temp = out[i]-mod[i]-carry;
        carry = (out[i]<mod[i] || mod[i]<carry) ? 1:0;
        out[i] = temp;
      }
      // end subtraction
      //subtract384_64bitlimbs(out, out, mod);

      return;
    }
    else if (out[i]<mod[i]) {
      // no subtraction needed
      return;
    }
  }

  // x and y are equal, so subtract

  // begin subtraction
  carry = 0;
#pragma unroll
  for (int i=0; i<(384/64);i++){
    temp = out[i]-mod[i]-carry;
    carry = (out[i]<mod[i] || mod[i]<carry) ? 1:0;
    out[i] = temp;
  }
  // end subtraction

  //subtract384_64bitlimbs(out, out, mod);

  return;
}

bool F1::Eq(F1 &other) {
    if (memcmp(&this->elem, &other.elem, 48) != 0) {
        return false;
    } else {
        return true;
    }
}

bool F2::Eq(F2 &other) {
    if (this->x.Eq(other.x) && this->y.Eq(other.y)) {
        return true;
    } else {
        return false;
    }
}

F1 F1::Add(F1 &other) {
    F1 result;

    uint64_t *a = reinterpret_cast<uint64_t *>(&this->elem);
    uint64_t *b = reinterpret_cast<uint64_t *>(&other.elem);
    uint64_t* ret = reinterpret_cast<uint64_t*>(&result.elem);

    addmod384_64bitlimbs(ret, a, b, BignumModulusPointer);

    return result;
}

F1 F1::Mul(F1 &other) {
    F1 result;

    uint64_t* a = reinterpret_cast<uint64_t*>(&this->elem);
    uint64_t* b = reinterpret_cast<uint64_t*>(&other.elem);
    uint64_t* ret = reinterpret_cast<uint64_t*>(&result.elem);

    montgomery_multiplication_384(a, b, BignumModulusPointer, BignumInvPointer, ret);

    return result;
}

F2 F2::MulNR() {
    return F2 {
        .x = this->x.Sub(this->y),
        .y = this->x.Add(this->y),
    };
}

F1 F1::Sub(F1 &other) {
    F1 result;

    intx::uint512* a = reinterpret_cast<intx::uint512*>(&this->elem);
    intx::uint512* b = reinterpret_cast<intx::uint512*>(&other.elem);
    intx::uint512* ret_mem = reinterpret_cast<intx::uint512*>(&result.elem);

    if (this->elem < other.elem) {
      result.elem = (this->elem + BignumModulus) - other.elem;
    } else {
      result.elem = this->elem - other.elem;
    }

    return result;
}

F2 F2::Mul(F2 &other) {
    F1 tmp, tmp2, zero;
    F2 result;

    // x = TODO
    tmp2 = this->y.Mul(other.y);
    result.x = zero.Sub(tmp2);
    tmp = this->x.Mul(other.x);
    result.x = result.x.Add(tmp);

    // y = TODO
    tmp2 = tmp2.Add(tmp);
    tmp = other.x.Add(other.y);
    result.y = this->x.Add(this->y);
    result.y = result.y.Mul(tmp);
    result.y = result.y.Sub(tmp2);

    return result;
}

F2 F2::Sub(F2 &other) {
    return F2 {
        .x = this->x.Sub(other.x),
        .y = this->y.Sub(other.y)
    };
}

F2 F2::Add(F2 &other) {
    return F2 {
        .x = this->x.Add(other.x),
        .y = this->y.Add(other.y)
    };
}

F6 F6::Mul(F6 &other) {
        F2 tmp1, tmp2, tmp3;
        F6 result;

        // TODO identify and remove redundant calcs: cache them

        // aA <- a * A
        F2 aA = this->a.Mul(other.a);

        /*
        std::cout << "a is \n" << this->a.to_string();
        std::cout << "other a is \n" << other.a.to_string();
        std::cout << "aA =\n" << aA.to_string();
        */

        // bB <- b * B
        F2 bB = this->b.Mul(other.b);

        //std::cout << "a is \n" << this->a.to_string();
        //std::cout << "other a is \n" << other.a.to_string();
        // std::cout << "bB =\n" << bB.to_string();

        // cC <- c * C
        F2 cC = this->c.Mul(other.c);

        // std::cout << "cC =\n" << cC.to_string();

        /* 
            result.c = ((a + c) * (A + C) - (a * A + c * C)) + bB
        */

        tmp1 = this->a.Add(this->c);
        tmp2 = other.a.Add(other.c);
        tmp3 = tmp1.Mul(tmp2);
        tmp1 = aA.Add(cC);
        tmp2 = tmp3.Sub(tmp1);
        result.c = bB.Add(tmp2);

        /*
            result.b = ((a_b * A_B) - aA_bB) + mulNonResidue(cC)
        */
        
        tmp1 = this->a.Add(this->b);
        tmp2 = other.a.Add(other.b);
        tmp3 = tmp2.Mul(tmp1);
        tmp1 = aA.Add(bB);
        tmp2 = tmp3.Sub(tmp1);
        tmp1 = cC.MulNR();
        result.b = tmp2.Add(tmp1);

        /*
            r0 = aA + mulNonResidueF2((b + c) * (B + C) - (b * B + c * C))
        */

        tmp1 = this->b.Add(this->c);
        tmp2 = other.b.Add(other.c);
        tmp3 = tmp2.Mul(tmp1);
        tmp1 = bB.Add(cC);
        tmp2 = tmp3.Sub(tmp1);
        tmp3 = tmp2.MulNR();
        result.a = tmp3.Add(aA);

        return result;
}

bool F6::Eq(F6 &other) {
    if (this->a.Eq(other.a) && this->b.Eq(other.b) && this->c.Eq(other.c)) {
        return true;
    } else {
        return false;
    }
}

std::string F6::to_string() {
    std::stringstream ss;
    ss << "a:\n" << this->a.to_string() << "\nb:\n" << this->b.to_string() << "\nc:\n" << this->c.to_string() << std::endl;
    return ss.str();
}

void test_f2m_mul(){
  std::cout << "f2m_mul test\n";
  uint8_t alloc_buf[1024];
  memset(&alloc_buf, 0, 1024);

  uint8_t *bls12_mod = reinterpret_cast<uint8_t *>(BignumModulusPointer);
  F2 ret;

  F2 expected_ret {
      .x = F1(intx::from_string<intx::uint512>("255764189013996354778530007569889001055067406624628718720350558819505010797856172019022025237994751597615902595098")),
      .y = F1(intx::from_string<intx::uint512>("2509967407620488813015098700274670883552258862174675734632103380713299579530676271073576398214258371611878896839089")),
  };

  F2 a {
    .x = F1(intx::from_string<intx::uint512>("0x0daa35e7a880a2ca3bcea128c5c8d17202945981a13aec134d10c051c1fa23c06b3088c3a380f4b8b1f598e5f390298f")),
    .y = F1(intx::from_string<intx::uint512>("0x0918e9882e10abce5a0f55c6916e3be87e5dc68b9d3324db632d33c3fb53868f77c0488c7e3ab230d54c6d90277a2d99")),
  };

  F2 b = {
      .x = F1(intx::from_string<intx::uint512>("0x15e1e13af71de9928b9b1631a9ecad43670a33daa7a418b44f0090b4b602e334f47665551a973a7a4c64af08c847d3ec")),
      .y = F1(intx::from_string<intx::uint512>("0x0d36ade56247620236b05713353330909e7bb1d29bbceb438dc379ad239bf6932d43750eb8e3d564d743e8119e82a212")),
  };

  ret = a.Mul(b);

  std::cout << "expected " << expected_ret.to_string() << "\ngot: " << ret.to_string() << "\n";
  if (!expected_ret.Eq(ret)) {
      std::cout << "failed\n";
  } else {
      std::cout << "passed\n";
  }
}

void test_f6m_mul() {
    std::cout << "testing f6m_mul\n";

    F6 p1 {
        .a = {
            .x = F1(intx::from_string<intx::uint512>("0x0daa35e7a880a2ca3bcea128c5c8d17202945981a13aec134d10c051c1fa23c06b3088c3a380f4b8b1f598e5f390298f")),
            .y = F1(intx::from_string<intx::uint512>("0x0918e9882e10abce5a0f55c6916e3be87e5dc68b9d3324db632d33c3fb53868f77c0488c7e3ab230d54c6d90277a2d99")),
        },
        .b = {
            .x = F1(intx::from_string<intx::uint512>("0x18a6c5f02807687486eee2410b7040ac5c0e564cabe64e12fb8c35578a61f36fed7413e994a3c6c4086f814671909972")),
            .y = F1(intx::from_string<intx::uint512>("0x00d2a9d9e2674057794afa89fcf3e8edb7b032354dddf7dd8268a83a92d72dd6b1931fec1cd2f8a052b99eb3627fd70f")),
        },
        .c = {
            .x = F1(intx::from_string<intx::uint512>("0x13ac019d8914d7479fe7c4731a4033251a384cb89a53b823e1c635ab7589a4a67eeff9aa243283c4b48c3db146de697a")),
            .y = F1(intx::from_string<intx::uint512>("0x181bf207cb40cbf95b6d18e0bf2789982fccb608f7b9fe2b9f78880e569b144d8f27ef73cbda9d1a6ac356810d0bfaa9")),
        }
    };

    F6 p2 {
        .a = {
            .x = F1(intx::from_string<intx::uint512>("0x15e1e13af71de9928b9b1631a9ecad43670a33daa7a418b44f0090b4b602e334f47665551a973a7a4c64af08c847d3ec")),
            .y = F1(intx::from_string<intx::uint512>("0x0d36ade56247620236b05713353330909e7bb1d29bbceb438dc379ad239bf6932d43750eb8e3d564d743e8119e82a212")),
        },
        .b = {
            .x = F1(intx::from_string<intx::uint512>("0x0fd4716804357d4012a717d278006dd37da44fed2763f9c4a69707d2e0948416495c6fc6faf993f3013366ce7d85f9d7")),
            .y = F1(intx::from_string<intx::uint512>("0x13a2fd8719f04ccb3910d3b47ff5044cd63ad849bfe1345e74aae8038d54a7e4d26a90e7bca076eb90c11e6c7f761b2f")),
        },
        .c = {
            .x = F1(intx::from_string<intx::uint512>("0x06d6c6cd0b01a8102b1be07b8558d51865b7cd0f3980d8f1e444c4cfcb379f2fedeea333d4b090588847aef2a28d3f7b")),
            .y = F1(intx::from_string<intx::uint512>("0x10f6503d1e2158bbdaf82c0121b3880c97ce174a73906ee53cb0e39a3e30fea5a9ad25588b867763788a2c13f6029c31")),
        }
    };

    F6 expected {
        .a = {
            .x = F1(intx::from_string<intx::uint512>("0x0e929cf37e24b30a658a997a1014c38782a91ea00b42d5b62300423b9220cdae82f6712eee5a66acea6850a3e0f4f3f4")),
            .y = F1(intx::from_string<intx::uint512>("0x08727ed9bc62fc242e2693adf24da55d65ba14cdadd0fcc021782b29b77cf88a64aaf4a965d123e6ad2ba293d920962c")),
        },
        .b = {
            .x = F1(intx::from_string<intx::uint512>("0x17ca0639b783a2e475f679efe11ce71b280ab24f0f6012a8b7dc9262027006946f57ebea873c094385165e6c8e83d1ea")),
            .y = F1(intx::from_string<intx::uint512>("0x0b125bf61e3d5acdd4198c7e2fd3d0af7f23281deaf20de1a555901d60872c9cf60923565d63d70db2455440762c8b9c")),
        },
        .c = {
            .x = F1(intx::from_string<intx::uint512>("0x18c774ca6acaf4bfff4f95a5c4f84e2983ee924817b19b3ebb5fc8db4990e0c15779a845f1beb783c9be4dc7f01e5940")),
            .y = F1(intx::from_string<intx::uint512>("0x08130179231df0116c0e2d2100dab1e5a8d29140b2dd79ebadd55250016d7eab84a0ed68bd215152bb635d1c8f2b249b")),
        }
    };

    auto result = p1.Mul(p2);
    std::cout << "got: \n" << result.to_string() << "\nexpected:\n" << expected.to_string() << std::endl;
    if (!result.Eq(expected)) {
        std::cout << "failed\n";
    } else {
        std::cout << "passed\n";
    }
}

int main(int argc, char** argv) {
  test_f2m_mul();
  test_f6m_mul();
  return 0;
}
