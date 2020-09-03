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


        // TODO cache zero as constant
        let zero := add(tmp2, 64)
        mstore(zero, 0x0000000000000000000000000000000000000000000000000000000000000000)
        mstore(add(zero, 32), 0x0000000000000000000000000000000000000000000000000000000000000000)

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

    function test_f2m_mul_loop() {
            mstore(4090, 0x01)

            let point1_a := msize()
            mstore(point1_a,          0x8f2990f3e598f5b1b8f480a3c388306bc023fac151c0104d13ec3aa181599402)
            mstore(add(point1_a, 32), 0x72d1c8c528a1ce3bcaa280a8e735aa0d00000000000000000000000000000000)
            mstore(add(point1_a, 64), 0x992d7a27906d4cd530b23a7e8c48c0778f8653fbc3332d63db24339d8bc65d7e)
            mstore(add(point1_a, 96), 0xe83b6e91c6550f5aceab102e88e9180900000000000000000000000000000000)

            let point1_b := add(point1_a, 128)
            mstore(point1_b,          0x7299907146816f08c4c6a394e91374ed6ff3618a57358cfb124ee6ab4c560e5c)
            mstore(add(point1_b, 32), 0xac40700b41e2ee8674680728f0c5a61800000000000000000000000000000000)
            mstore(add(point1_b, 64), 0x0fd77f62b39eb952a0f8d21cec1f93b1d62dd7923aa86882ddf7dd4d3532b0b7)
            mstore(add(point1_b, 96), 0xede8f3fc89fa4a79574067e2d9a9d20000000000000000000000000000000000)

            let f2m_result := add(point1_b, 384) // allocate memory past bls12_mod

            let mem := add(f2m_result, 128)

            f2m_mul(point1_a, point1_b, f2m_result, mem)

            let i := 0
            for {} lt(i, 1350) {i := add(i, 1)} {
                f2m_mul(point1_a, f2m_result, point1_b, mem)
                f2m_mul(point1_b, f2m_result, point1_a, mem)
            }

            return(f2m_result, 128)
    }

    test_f2m_mul_loop()
}
