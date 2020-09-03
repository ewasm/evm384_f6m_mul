{
    function zero512(dst) {
        mstore(dst, 0)
	mstore(add(dst, 32), 0)
    }

    // r <- x * y
    function f2m_mul(x, y, r, modulus, inv, mem) {
        
        let tmp := add(mem, 64)
        let tmp2 := add(tmp, 64)
        let zero := add(tmp2, 64)
	zero512(zero)

        // TODO also cache x0y0 calculation

        // tmp2 = x1y1
        mulmodmont384(tmp2, add(x, 64), add(y, 64), modulus, inv)

        //r0 = mulNR(tmp2)
        submod384(r, zero, tmp2, modulus)

        // tmp = x0y0
        mulmodmont384(tmp, x, y, modulus, inv)

        //r0 = r0 + tmp (x0y0)
        addmod384(r, r, tmp, modulus)

        // r1 -------------------------------------

        // r1 = ((y0 + y1) * (x0 + x1)) - ((x0 * y0) + (x1 * y1))

        // tmp2 <- tmp (x0 * y0) + tmp2 (x1 * y1)
        addmod384(tmp2, tmp, tmp2, modulus)

        // tmp = y0 + y1
        addmod384(tmp, y, add(y, 64), modulus)

        // r1 = x0 + x1
        addmod384(add(r, 64), x, add(x, 64), modulus)

        // r1 <- r1 (x0 + x1) * tmp (y0 + y1)
        mulmodmont384(add(r, 64), add(r, 64), tmp, modulus, inv)

        // r1 = r1 [(x0 + x1) * (y0 + y1)] - tmp2 [(x0 * y0) + (x1 * y1)]
        submod384(add(r, 64), add(r, 64), tmp2, modulus)
    }

    function test_f2m_mul_loop() {
            let bls12_mod := msize()
            mstore(bls12_mod,          0xabaafffffffffeb9ffff53b1feffab1e24f6b0f6a0d23067bf1285f3844b7764)
            mstore(add(bls12_mod, 32), 0xd7ac4b43b6a71b4b9ae67f39ea11011a00000000000000000000000000000000)

            let inv :=         0x89f3fffcfffcfffd
            let point1_a := add(bls12_mod, 64)
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

            f2m_mul(point1_a, point1_b, f2m_result, bls12_mod, inv, mem)

            let i := 0
            for {} lt(i, 1350) {i := add(i, 1)} {
                f2m_mul(point1_a, f2m_result, point1_b, bls12_mod, inv, mem)
                f2m_mul(point1_b, f2m_result, point1_a, bls12_mod, inv, mem)
            }

            return(f2m_result, 128)
    }

    test_f2m_mul_loop()
}
