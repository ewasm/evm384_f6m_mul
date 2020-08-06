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

#define BIGINT_BITS 384
#define LIMB_BITS 64
#define LIMB_BITS_OVERFLOW 128
#include "bigint.h"

void mulNR2(uint8_t* x0, uint8_t* x1, uint8_t* r0, uint8_t* r1, uint8_t* modulus){
  //printf("mulNR2()\n");
  FUNCNAME(submod)((uint64_t*)r0,(uint64_t*)x0,(uint64_t*)x1,(uint64_t*)modulus);
  FUNCNAME(addmod)((uint64_t*)r1,(uint64_t*)x0,(uint64_t*)x1,(uint64_t*)modulus);
}

void f2m_add(uint8_t* x0, uint8_t* x1, uint8_t* y0, uint8_t* y1, uint8_t* r0, uint8_t* r1, uint8_t* modulus, uint8_t* arena){
  //printf("f2m_add()\n");
  FUNCNAME(addmod)((uint64_t*)r0,(uint64_t*)x0,(uint64_t*)y0,(uint64_t*)modulus);
  FUNCNAME(addmod)((uint64_t*)r1,(uint64_t*)x1,(uint64_t*)y1,(uint64_t*)modulus);
}

void f2m_sub(uint8_t* x0, uint8_t* x1, uint8_t* y0, uint8_t* y1, uint8_t* r0, uint8_t* r1, uint8_t* modulus, uint8_t* arena){
  //printf("f2m_sub()\n");
  FUNCNAME(submod)((uint64_t*)r0,(uint64_t*)x0,(uint64_t*)y0,(uint64_t*)modulus);
  FUNCNAME(submod)((uint64_t*)r1,(uint64_t*)x1,(uint64_t*)y1,(uint64_t*)modulus);
}

void f2m_mul(uint8_t* x, uint8_t* y, uint8_t* r, uint8_t* modulus, uint64_t inv, uint8_t* mem){
  //printf("f2m_mul()\n");
  uint8_t* tmp = mem+64;
  uint8_t* tmp2 = tmp+64;
  uint8_t* zero = tmp2+64;
 
  FUNCNAME(mulmodmont)((uint64_t*)tmp2,(uint64_t*)(x+64),(uint64_t*)(y+64),(uint64_t*)modulus,inv);
  FUNCNAME(submod)((uint64_t*)r,(uint64_t*)zero,(uint64_t*)tmp2,(uint64_t*)modulus);
  FUNCNAME(mulmodmont)((uint64_t*)tmp,(uint64_t*)x,(uint64_t*)y,(uint64_t*)modulus,inv);
  FUNCNAME(addmod)((uint64_t*)r,(uint64_t*)r,(uint64_t*)tmp,(uint64_t*)modulus);

  //FUNCNAME(mulmodmont)((uint64_t*)tmp2,(uint64_t*)(x+64),(uint64_t*)(y+64),(uint64_t*)modulus,inv);	// why is this repeated from above?
  FUNCNAME(addmod)((uint64_t*)tmp2,(uint64_t*)tmp,(uint64_t*)tmp2,(uint64_t*)modulus);
  FUNCNAME(addmod)((uint64_t*)tmp,(uint64_t*)y,(uint64_t*)(y+64),(uint64_t*)modulus);
  FUNCNAME(addmod)((uint64_t*)(r+64),(uint64_t*)x,(uint64_t*)(x+64),(uint64_t*)modulus);
  FUNCNAME(mulmodmont)((uint64_t*)(r+64),(uint64_t*)(r+64),(uint64_t*)tmp,(uint64_t*)modulus,inv);
  FUNCNAME(submod)((uint64_t*)(r+64),(uint64_t*)(r+64),(uint64_t*)tmp2,(uint64_t*)modulus);

}

void f6m_mul_r2(uint8_t* abc, uint8_t* ABC, uint8_t* aA, uint8_t* bB, uint8_t* cC, uint8_t* r2, uint8_t* modulus, uint64_t inv, uint8_t* mem){
  //printf("f6m_mul_r2()\n");
  uint8_t* tmp1 = mem;
  uint8_t* tmp2 = mem+128;
  uint8_t* tmp3 = tmp2+128;
  uint8_t* arena = tmp3+128;

  f2m_add(abc,abc+64,abc+256,abc+320,tmp1,tmp1+64,modulus,arena);
  f2m_add(ABC,ABC+64,ABC+256,ABC+320,tmp2,tmp2+64,modulus,arena);

  f2m_mul(tmp1,tmp2,tmp3,modulus,inv,arena);
  f2m_add(aA,aA+64,cC,cC+64,tmp1,tmp1+64,modulus,arena);
  f2m_sub(tmp3,tmp3+64,tmp1,tmp1+64,tmp2,tmp2+64,modulus,arena);
  f2m_add(tmp2,tmp2+64,bB,bB+64,r2,r2+64,modulus,arena);
}

void f6m_mul_r1(uint8_t* abc, uint8_t* ABC, uint8_t* aA, uint8_t* bB, uint8_t* cC, uint8_t* r1, uint8_t* modulus, uint64_t inv, uint8_t* mem){
  //printf("f6m_mul_r1()\n");
  uint8_t* tmp1 = mem;
  uint8_t* tmp2 = mem+128;
  uint8_t* tmp3 = tmp2+128;
  uint8_t* arena = tmp3+128;

  f2m_add(abc,abc+64,abc+128,abc+192,tmp1,tmp1+64,modulus,arena);
  f2m_add(ABC,ABC+64,ABC+128,ABC+192,tmp2,tmp2+64,modulus,arena);

  f2m_mul(tmp2,tmp1,tmp3,modulus,inv,arena);
  f2m_add(aA,aA+64,bB,bB+64,tmp1,tmp1+64,modulus,arena);
  f2m_sub(tmp3,tmp3+64,tmp1,tmp1+64,tmp2,tmp2+64,modulus,arena);
  mulNR2(cC,cC+64,tmp1,tmp1+64,modulus);
  f2m_add(tmp2,tmp2+64,tmp1,tmp1+64,r1,r1+64,modulus,arena);

}

void f6m_mul_r0(uint8_t* abc, uint8_t* ABC, uint8_t* aA, uint8_t* bB, uint8_t* cC, uint8_t* r0, uint8_t* modulus, uint64_t inv, uint8_t* mem){
  //printf("f6m_mul_r0()\n");
  uint8_t* tmp1 = mem;
  uint8_t* tmp2 = mem+128;
  uint8_t* tmp3 = tmp2+128;
  uint8_t* arena = tmp3+128;

  f2m_add(abc+128,abc+192,abc+256,abc+320,tmp1,tmp1+64,modulus,arena);
  f2m_add(ABC+128,ABC+192,ABC+256,ABC+320,tmp2,tmp2+64,modulus,arena);

  f2m_mul(tmp1,tmp2,tmp3,modulus,inv,arena);
  f2m_add(bB,bB+64,cC,cC+64,tmp1,tmp1+64,modulus,arena);
  f2m_sub(tmp3,tmp3+64,tmp1,tmp1+64,tmp2,tmp2+64,modulus,arena);
  mulNR2(tmp2,tmp2+64,tmp3,tmp3+64,modulus);
  f2m_add(tmp3,tmp3+64,aA,aA+64,r0,r0+64,modulus,arena);
}

void f6m_mul(uint8_t* abc, uint8_t* ABC, uint8_t* r, uint8_t* modulus, uint64_t inv, uint8_t* mem){
  //printf("f6m_mul()\n");
  uint8_t* aA = mem;
  uint8_t* bB = aA+128;
  uint8_t* cC = bB+128;
  uint8_t* arena = cC+128;

  f2m_mul(abc,ABC,aA,modulus,inv,arena);
  f2m_mul(abc+128,ABC+128,bB,modulus,inv,arena);
  f2m_mul(abc+256,ABC+256,cC,modulus,inv,arena);

  f6m_mul_r2(abc,ABC,aA,bB,cC,r+256,modulus,inv,arena);
  f6m_mul_r1(abc,ABC,aA,bB,cC,r+128,modulus,inv,arena);
  f6m_mul_r0(abc,ABC,aA,bB,cC,r,modulus,inv,arena);
}

void test_f6m_mul(){
  printf("f6m_mul test\n");
  uint64_t buffer[] = {
	  //a
	          0x8f2990f3e598f5b1, 0xb8f480a3c388306b, 0xc023fac151c0104d, 0x13ec3aa181599402,
	          0x72d1c8c528a1ce3b, 0xcaa280a8e735aa0d, 0x0000000000000000, 0x0000000000000000,
		  0x992d7a27906d4cd5, 0x30b23a7e8c48c077, 0x8f8653fbc3332d63, 0xdb24339d8bc65d7e,
		  0xe83b6e91c6550f5a, 0xceab102e88e91809, 0x0000000000000000, 0x0000000000000000,
          //b
	          0x7299907146816f08, 0xc4c6a394e91374ed, 0x6ff3618a57358cfb, 0x124ee6ab4c560e5c,
	          0xac40700b41e2ee86, 0x74680728f0c5a618, 0x0000000000000000, 0x0000000000000000,
		  0x0fd77f62b39eb952, 0xa0f8d21cec1f93b1, 0xd62dd7923aa86882, 0xddf7dd4d3532b0b7,
		  0xede8f3fc89fa4a79, 0x574067e2d9a9d200, 0x0000000000000000, 0x0000000000000000,
          //c
	          0x7a69de46b13d8cb4, 0xc4833224aaf9ef7e, 0xa6a48975ab35c6e1, 0x23b8539ab84c381a,
	          0x2533401a73c4e79f, 0x47d714899d01ac13, 0x0000000000000000, 0x0000000000000000,
		  0xa9fa0b0d8156c36a, 0x1a9ddacb73ef278f, 0x4d149b560e88789f, 0x2bfeb9f708b6cc2f,
		  0x988927bfe0186d5b, 0xf9cb40cb07f21b18, 0x0000000000000000, 0x0000000000000000,
          //A
	          0xecd347c808af644c, 0x7a3a971a556576f4, 0x34e302b6b490004f, 0xb418a4a7da330a67,
	          0x43adeca931169b8b, 0x92e91df73ae1e115, 0x0000000000000000, 0x0000000000000000,
		  0x12a2829e11e843d7, 0x64d5e3b80e75432d, 0x93f69b23ad79c38d, 0x43ebbc9bd2b17b9e,
		  0x903033351357b036, 0x02624762e5ad360d, 0x0000000000000000, 0x0000000000000000,
          //B
	          0xd7f9857dce663301, 0xf393f9fac66f5c49, 0x168494e0d20797a6, 0xc4f96327ed4fa47d,
	          0xd36d0078d217a712, 0x407d35046871d40f, 0x0000000000000000, 0x0000000000000000,
	          0x2f1b767f6c1ec190, 0xeb76a0bce7906ad2, 0xe4a7548d03e8aa74, 0x5e34e1bf49d83ad6,
		  0x4c04f57fb4d31039, 0xcb4cf01987fda213, 0x0000000000000000, 0x0000000000000000,
          //C
	          0x7b3f8da2f2ae4788, 0x5890b0d433a3eeed, 0x2f9f37cbcfc444e4, 0xf1d880390fcdb765,
	          0x18d558857be01b2b, 0x10a8010bcdc6d606, 0x0000000000000000, 0x0000000000000000,
		  0x319c02f6132c8a78, 0x6377868b5825ada9, 0xa5fe303e9ae3b03c, 0xe56e90734a17ce97,
		  0x0c88b321012cf8da, 0xbb58211e3d50f610, 0x0000000000000000, 0x0000000000000000,
          //r_0
	          0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
          //r_1
	          0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
          //r_2
	          0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
     //bls12_mod
                  0xabaafffffffffeb9, 0xffff53b1feffab1e, 0x24f6b0f6a0d23067, 0xbf1285f3844b7764,
 	          0xd7ac4b43b6a71b4b, 0x9ae67f39ea11011a, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
     //mem
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                 };
 
  uint8_t* a = (uint8_t*)buffer;
  uint8_t* b = a+128;
  uint8_t* c = b+128;
  uint8_t* A = c+128;
  uint8_t* B = A+128;
  uint8_t* C = B+128;

  uint8_t* r_0 = C+128;
  uint8_t* r_1 = r_0+128;
  uint8_t* r_2 = r_1+128;

  uint8_t* bls12_mod = r_2+128;
  uint64_t bls12_r_inv = 0x89f3fffcfffcfffd;
  
  f6m_mul(a,A,r_0,bls12_mod,bls12_r_inv,bls12_mod+128);

  uint64_t* output = (uint64_t*)r_0;
  uint64_t expected[] = {
           //r_0
		  0xf4f3f4e0a35068ea, 0xac665aee2e71f682, 0xaecd20923b420023, 0xb6d5420ba01ea982,
		  0x87c314107a998a65, 0x0ab3247ef39c920e, 0x0000000000000000, 0x0000000000000000,
                  0x2c9620d993a22bad, 0xe623d165a9f4aa64, 0x8af87cb7292b7821, 0xc0fcd0adcd14ba65,
		  0x5da54df2ad93262e, 0x24fc62bcd97e7208, 0x0000000000000000, 0x0000000000000000,
	  //r_1
	          0xead1838e6c5e1685, 0x43093c87eaeb576f, 0x940670026292dcb7, 0xa812600f4fb20a28,
		  0x1be71ce1ef79f675, 0xe4a283b73906ca17, 0x0000000000000000, 0x0000000000000000,
		  0x9c8b2c76405445b2, 0x0dd7635d562309f6, 0x9c2c87601d9055a5, 0xe10df2ea1d28237f,
		  0xafd0d32f7e8c19d4, 0xcd5a3d1ef65b120b, 0x0000000000000000, 0x0000000000000000,
	  //r_2
	          0x40591ef0c74dbec9, 0x83b7bef145a87957, 0xc1e09049dbc85fbb, 0x3e9bb1174892ee83,
		  0x294ef8c4a5954fff, 0xbff4ca6aca74c718, 0x0000000000000000, 0x0000000000000000,
		  0x9b242b8f1c5d63bb, 0x525121bd68eda084, 0xab7e6d015052d5ad, 0xeb79ddb24091d2a8,
		  0xe5b1da00212d0e6c, 0x11f01d2379011308, 0x0000000000000000, 0x0000000000000000,
                };

  for (int i=0; i<48; i++){
    if (output[i]!=expected[i]){
      printf("ERROR %i %lx %lx\n",i, output[i], expected[i]);
      break;
    }
  }
	          
}


void test_f2m_mul(){
  printf("f2m_mul test\n");
  uint64_t bls12_r_inv = 0x89f3fffcfffcfffd;
  uint64_t buffer[] = {
	  //bls12_mod
                  0xabaafffffffffeb9, 0xffff53b1feffab1e, 0x24f6b0f6a0d23067, 0xbf1285f3844b7764,
 	          0xd7ac4b43b6a71b4b, 0x9ae67f39ea11011a, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
          //x
	          0x8f2990f3e598f5b1, 0xb8f480a3c388306b, 0xc023fac151c0104d, 0x13ec3aa181599402,
		  0x72d1c8c528a1ce3b, 0xcaa280a8e735aa0d, 0x0000000000000000, 0x0000000000000000,
		  0x992d7a27906d4cd5, 0x30b23a7e8c48c077, 0x8f8653fbc3332d63, 0xdb24339d8bc65d7e,
		  0xe83b6e91c6550f5a, 0xceab102e88e91809, 0x0000000000000000, 0x0000000000000000,
          //y     
	          0xecd347c808af644c, 0x7a3a971a556576f4, 0x34e302b6b490004f, 0xb418a4a7da330a67,
		  0x43adeca931169b8b, 0x92e91df73ae1e115, 0x0000000000000000, 0x0000000000000000,
		  0x12a2829e11e843d7, 0x64d5e3b80e75432d, 0x93f69b23ad79c38d, 0x43ebbc9bd2b17b9e,
		  0x903033351357b036, 0x02624762e5ad360d, 0x0000000000000000, 0x0000000000000000,
          //r     
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                  0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000,
                };

  uint8_t* bls12_mod = (uint8_t*)buffer;
  uint8_t* x = bls12_mod+128;
  uint8_t* y = x+128;
  uint8_t* r = y+128;

  f2m_mul(x,y,r,bls12_mod,bls12_r_inv,r+128);

  uint64_t* output = (uint64_t*)r;
  uint64_t expected[] = {
           //r
		  0x1a984f235709ab39, 0x41e22b5e67d5ba89, 0x2ce9242e227c0c6b, 0xb38aa1ace4d4b64a,
	          0xaba753d350d98f4c, 0x05570f525d67a901, 0x0000000000000000, 0x0000000000000000,
		  0xb1297e4e9ca0c757, 0xdfe693ea0d2f5216, 0xdaeaa4ad06964e2f, 0x7c242200049d386d,
		  0x860b25d4718a2c42, 0x40fb89c90abe4e10, 0x0000000000000000, 0x0000000000000000,
                };

  for (int i=0; i<16; i++){
    if (output[i]!=expected[i]){
      printf("ERROR %i %lx %lx\n",i, output[i], expected[i]);
      break;
    }
  }


}

int main(int argc, char** argv){
  test_f6m_mul();	// doesn't pass
  test_f2m_mul();	// doesn't pass
  return 0;
}
