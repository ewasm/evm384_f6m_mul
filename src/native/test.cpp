// #include "f6m_mul.h" TODO how to fix linker error 
#include<iostream>
#include "f6m_mul.cpp"

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
