{
    function memcpy_384(dst, src) {
        let hi := mload(src)
        let lo := mload(add(src, 32))
        mstore(dst, hi)
        mstore(add(dst, 32), lo)
    }

    function mulNR2(x0, x1, r0, r1) {
        // r0 <- x0 - x1
        submod384(r0, x0, x1)
        // r1 <- x0 + x1
        addmod384(r1, x0, x1)
    }

    // r <- x + y
    function f2m_add(x_0, x_1, y_0, y_1, r_0, r_1, arena) {
        addmod384(r_0, x_0, y_0)
        addmod384(r_1, x_1, y_1)
    }

    // r <- x - y
    function f2m_sub(x_0, x_1, y_0, y_1, r_0, r_1, arena) {
        submod384(r_0, x_0, y_0)
        submod384(r_1, x_1, y_1)
    }

    // r <- x * y
    function f2m_mul(x, y, r, mem) {
        
        let tmp := add(mem, 64)
        let tmp2 := add(tmp, 64)

        let zero := 2000

        // TODO also cache x0y0 calculation

        // tmp2 = x1y1
        mulmodmont384(tmp2, add(x, 64), add(y, 64))

        //r0 = mulNR(tmp2)
        submod384(r, zero, tmp2)

        // tmp = x0y0
        mulmodmont384(tmp, x, y)

        //r0 = r0 + tmp (x0y0)
        addmod384(r, r, tmp)

        // r1 -------------------------------------

        // r1 = ((y0 + y1) * (x0 + x1)) - ((x0 * y0) + (x1 * y1))

        // tmp2 <- tmp (x0 * y0) + tmp2 (x1 * y1)
        addmod384(tmp2, tmp, tmp2)

        // tmp = y0 + y1
        addmod384(tmp, y, add(y, 64))

        // r1 = x0 + x1
        addmod384(add(r, 64), x, add(x, 64))

        // r1 <- r1 (x0 + x1) * tmp (y0 + y1)
        mulmodmont384(add(r, 64), add(r, 64), tmp)

        // r1 = r1 [(x0 + x1) * (y0 + y1)] - tmp2 [(x0 * y0) + (x1 * y1)]
        submod384(add(r, 64), add(r, 64), tmp2)
    }

    function f6m_mul_r2(abc, ABC,aA,bB,cC,r2, mem) {
        /* 
            r_2 <- ((a + c) * (A + C) - (a * A + c * C)) + bB
        */

        let tmp1 := mem
        let tmp2 := add(mem, 128)
        let tmp3 := add(tmp2, 128)

        let arena := add(tmp3, 128)

        // tmp1 <- a + c
        f2m_add(abc, add(abc, 64), add(abc, 256), add(abc, 320), tmp1, add(tmp1, 64), arena)

        // tmp2 <- A + C
        f2m_add(ABC, add(ABC, 64), add(ABC, 256), add(ABC, 320), tmp2, add(tmp2, 64), arena)

        // tmp3 <- tmp1 * tmp2
        f2m_mul(tmp1, tmp2, tmp3, arena)

        // tmp1 <- aA + cC
        f2m_add(aA, add(aA, 64), cC, add(cC, 64), tmp1, add(tmp1, 64), arena)

        // tmp2 <- tmp3 - tmp1
        f2m_sub(tmp3, add(tmp3, 64), tmp1, add(tmp1, 64), tmp2, add(tmp2, 64), arena)

        // r_2 <- bB + tmp2 
        f2m_add(tmp2, add(tmp2, 64), bB, add(bB, 64), r2, add(r2, 64), arena)
    }


    /*
        r1 = ((a_b * A_B) - aA_bB) + mulNonResidue(cC)
    */
    function f6m_mul_r1(abc, ABC, aA, bB, cC, r1, mem) {
        let tmp1 := mem
        let tmp2 := add(mem, 128)
        let tmp3 := add(tmp2, 128)
        let arena := add(tmp3, 128)

        // tmp1 <- a + b
        f2m_add(abc, add(abc, 64), add(abc, 128), add(abc, 192), tmp1, add(tmp1, 64), arena)
        
        // tmp2 <- A + B
        f2m_add(ABC, add(ABC, 64), add(ABC, 128), add(ABC, 192), tmp2, add(tmp2, 64), arena)

        // tmp3 <- tmp2 * tmp1
        f2m_mul(tmp2, tmp1, tmp3, arena)

        // tmp1 <- aA * bB
        f2m_add(aA, add(aA, 64), bB, add(bB, 64), tmp1, add(tmp1, 64), arena)

        // tmp2 <- tmp3 - tmp1
        f2m_sub(tmp3, add(tmp3, 64), tmp1, add(tmp1, 64), tmp2, add(tmp2, 64), arena)

        // tmp1 <- mulNonResidue(cC)
        mulNR2(cC, add(cC, 64), tmp1, add(tmp1, 64))

        // r_1 <- tmp2 + tmp1
        f2m_add(tmp2, add(tmp2, 64), tmp1, add(tmp1, 64), r1, add(r1, 64), arena)
    }

    function f6m_mul_r0(abc, ABC, aA, bB, cC, r0, mem) {
        /*
            r0 = aA + mulNonResidue((b + c) * (B + C) - (b * B + c * C))
        */

        let tmp1 := mem
        let tmp2 := add(mem, 128)
        let tmp3 := add(tmp2, 128)
        let arena := add(tmp3, 128)

        // tmp1 <- b + c
        f2m_add(add(abc, 128), add(abc, 192), add(abc, 256), add(abc, 320), tmp1, add(tmp1, 64), arena)

        // tmp2 <- B + C
        f2m_add(add(ABC, 128), add(ABC, 192), add(ABC, 256), add(ABC, 320), tmp2, add(tmp2, 64), arena)

        // tmp3 <- tmp2 * tmp1
        f2m_mul(tmp1, tmp2, tmp3, arena)

        // tmp1 <- bB + cC
        f2m_add(bB, add(bB, 64), cC, add(cC, 64), tmp1, add(tmp1, 64), arena)

        // tmp2 <- tmp3 - tmp1
        f2m_sub(tmp3, add(tmp3, 64), tmp1, add(tmp1, 64), tmp2, add(tmp2, 64), arena)

        // tmp3 <- mulnonresidue(tmp2)
        mulNR2(tmp2, add(tmp2, 64), tmp3, add(tmp3, 64))

        // r0 <- tmp3 + aA
        f2m_add(tmp3, add(tmp3, 64), aA, add(aA, 64), r0, add(r0, 64), arena)
    }

    // {r_0, r_1, r_2} <- {a, b, c} * {A, B, C}
    function f6m_mul(abc, ABC, r, arena) {
        let aA := arena
        let bB := add(aA, 128)
        let cC := add(bB, 128)

        arena := add(cC, 128)
        // all memory after 'arena' should be unused

        // aA <- a * A
        f2m_mul(abc, ABC, aA, arena)

        // bB <- b * B
        f2m_mul(add(abc, 128), add(ABC, 128), bB, arena)

        // cC <- c * C
        f2m_mul(add(abc, 256), add(ABC, 256), cC, arena)

        f6m_mul_r2(abc, ABC, aA, bB, cC, add(r, 256), arena)
        f6m_mul_r1(abc, ABC, aA, bB, cC, add(r, 128), arena)
        f6m_mul_r0(abc, ABC, aA, bB, cC, r, arena)
    }
    function test_f6m_mul_loop() {
            mstore(4090, 0x01)

            let point1_a := 0

            mstore(point1_a,          0x8f2990f3e598f5b1b8f480a3c388306bc023fac151c0104d13ec3aa181599402)
            mstore(add(point1_a, 32), 0x72d1c8c528a1ce3bcaa280a8e735aa0d00000000000000000000000000000000)
            mstore(add(point1_a, 64), 0x992d7a27906d4cd530b23a7e8c48c0778f8653fbc3332d63db24339d8bc65d7e)
            mstore(add(point1_a, 96), 0xe83b6e91c6550f5aceab102e88e9180900000000000000000000000000000000)

            let point1_b := add(point1_a, 128)
            mstore(point1_b,          0x7299907146816f08c4c6a394e91374ed6ff3618a57358cfb124ee6ab4c560e5c)
            mstore(add(point1_b, 32), 0xac40700b41e2ee8674680728f0c5a61800000000000000000000000000000000)
            mstore(add(point1_b, 64), 0x0fd77f62b39eb952a0f8d21cec1f93b1d62dd7923aa86882ddf7dd4d3532b0b7)
            mstore(add(point1_b, 96), 0xede8f3fc89fa4a79574067e2d9a9d20000000000000000000000000000000000)

            let point1_c := add(point1_b, 128)
            mstore(point1_c,          0x7a69de46b13d8cb4c4833224aaf9ef7ea6a48975ab35c6e123b8539ab84c381a)
            mstore(add(point1_c, 32), 0x2533401a73c4e79f47d714899d01ac1300000000000000000000000000000000)
            mstore(add(point1_c, 64), 0xa9fa0b0d8156c36a1a9ddacb73ef278f4d149b560e88789f2bfeb9f708b6cc2f)
            mstore(add(point1_c, 96), 0x988927bfe0186d5bf9cb40cb07f21b1800000000000000000000000000000000)

            let point2_A := add(point1_c, 128)
            mstore(point2_A,          0xecd347c808af644c7a3a971a556576f434e302b6b490004fb418a4a7da330a67)
            mstore(add(point2_A, 32), 0x43adeca931169b8b92e91df73ae1e11500000000000000000000000000000000)
            mstore(add(point2_A, 64), 0x12a2829e11e843d764d5e3b80e75432d93f69b23ad79c38d43ebbc9bd2b17b9e)
            mstore(add(point2_A, 96), 0x903033351357b03602624762e5ad360d00000000000000000000000000000000)

            let point2_B := add(point2_A, 128)
            mstore(point2_B,          0xd7f9857dce663301f393f9fac66f5c49168494e0d20797a6c4f96327ed4fa47d)
            mstore(add(point2_B, 32), 0xd36d0078d217a712407d35046871d40f00000000000000000000000000000000)
            mstore(add(point2_B, 64), 0x2f1b767f6c1ec190eb76a0bce7906ad2e4a7548d03e8aa745e34e1bf49d83ad6)
            mstore(add(point2_B, 96), 0x4c04f57fb4d31039cb4cf01987fda21300000000000000000000000000000000)

            let point2_C := add(point2_B, 128)
            mstore(point2_C,          0x7b3f8da2f2ae47885890b0d433a3eeed2f9f37cbcfc444e4f1d880390fcdb765)
            mstore(add(point2_C, 32), 0x18d558857be01b2b10a8010bcdc6d60600000000000000000000000000000000)
            mstore(add(point2_C, 64), 0x319c02f6132c8a786377868b5825ada9a5fe303e9ae3b03ce56e90734a17ce97)
            mstore(add(point2_C, 96), 0x0c88b321012cf8dabb58211e3d50f61000000000000000000000000000000000)



            let f6m_result1 := add(point2_C, 384) // allocate memory past bls12_mod
            let f6m_result2 := add(f6m_result1, 384)
            let f6m_result3 := add(f6m_result2, 384)
            let f6m_result4 := add(f6m_result3, 384)
            let f6m_result5 := add(f6m_result4, 384)

            let f6m_scratch_spaace := add(f6m_result5, 384)

            // just test one call
            //f6m_mul(point1_a, point2_A, f6m_result1, f6m_scratch_spaace)

            f6m_mul(point1_a, point2_A, f6m_result4, f6m_scratch_spaace)

            f6m_mul(point1_a, f6m_result4, f6m_result5, f6m_scratch_spaace)

            let i := 0
            for {} lt(i, 135) {i := add(i, 1)} {
                f6m_mul(f6m_result4, f6m_result5, f6m_result1, f6m_scratch_spaace)
                f6m_mul(f6m_result5, f6m_result1, f6m_result2, f6m_scratch_spaace)
                f6m_mul(f6m_result1, f6m_result2, f6m_result3, f6m_scratch_spaace)
                f6m_mul(f6m_result2, f6m_result3, f6m_result4, f6m_scratch_spaace)
                f6m_mul(f6m_result3, f6m_result4, f6m_result5, f6m_scratch_spaace)

                f6m_mul(f6m_result4, f6m_result5, f6m_result1, f6m_scratch_spaace)
                f6m_mul(f6m_result5, f6m_result1, f6m_result2, f6m_scratch_spaace)
                f6m_mul(f6m_result1, f6m_result2, f6m_result3, f6m_scratch_spaace)
                f6m_mul(f6m_result2, f6m_result3, f6m_result4, f6m_scratch_spaace)
                f6m_mul(f6m_result3, f6m_result4, f6m_result5, f6m_scratch_spaace)
            }

            return(f6m_result5, 64)
    }


/*
for a loop of 10, result should be:
2cf104a6407a2e8ce662ca3dc99bd1e97c62896e29e1e8291980a7fa306fb27056a3132b5e4c6c20f73542329c263e11
// 113e269c... (little endian)
7d32a392d6e84c5a1919e67a5c1b1bfa1ff6cc88e550b4578b18745e9568078c3dfac3a48f61dfc225e4edd33882790b
// 0b798238...
c58f113de32445bb24260d6d7524850bf55cb511f92945f519a88dd5c7cce1c977eda1ca61365baf70342b2ab6ab2216
// 1622abb6...
e1726632f1f1113f56386497ad044f9da494cc6d38b28d8c6df1b43c6e00f2eec931518850e130678262c7c12f330804
// 0408332fc1...
d69dfeb1abd4b977994892df84b22abcc092d0858fcccff85a2a2e72802960254583702e3e367a76bfd476da2e013f04
// 043f012eda...
97a886f1a62bffb25b2d6722149ae489d3c0c94babac1d18dab10a6e15cb6d89e4f3b3cddb9262666a23ebbf20eff809
// 09f8ef20bf...
*/

/*
for a loop of 135, result should be:
74229fc665e6c3f4401905c1a454ea57c8931739d05a074fd60400f19684d680a9e1305c25f13613dcc6cdd6e6e57d08
//087de5... (little endian)
66643d9f8c88aa618bbad33cfdd371c73a6378e4863e9b1368f79da18a0c6b5acb958e62ea89bbf52e40a34870ef8d04
//048def70...
511a414c750669a57a3f7e97e1d893240773e1c949b2c3eeeec9bd383087955052341dfff2ab76ea37efdda91005dc03
//03dc0510a9...
27ca26dff3265aa1e0ce3e8214b110d89a415996524226b1b0754135657ff01a3cc372830380986070f0f05c1a14dc04
//04dc141a5c...
f200f1e7c3f85d7cc7172d981654b827b60dced38b6f51ab8fb837669c310aaed71cfa12e470443ce9cbd8ec68c64005
//0540c668ec...
c4ec5f1698368dda3049991ea7d283af249b54f2e22006b8d7f9727dd160aff5af3f53dec4c586c5cd581bba6ef3dd0a
//0addf36eba...
*/

    test_f6m_mul_loop()
}
