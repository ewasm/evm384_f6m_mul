#!/bin/bash

./evmc run --vm libevmone.dylib,O=0,trace `cat miller_loop_v3.hex` | grep -E "[A-Z0-9][A-Z9-9][A-Z0-9]+" >miller_loop_v3.trace
./evmc run --vm libevmone.dylib,O=0,trace `cat miller_loop_v4.hex` | grep -E "[A-Z0-9][A-Z9-9][A-Z0-9]+" >miller_loop_v4.trace
./evmc run --vm libevmone.dylib,O=0,trace `cat final_exponentiation_v3.hex` | grep -E "[A-Z0-9][A-Z9-9][A-Z0-9]+" >final_exponentiation_v3.trace
./evmc run --vm libevmone.dylib,O=0,trace `cat final_exponentiation_v4.hex` | grep -E "[A-Z0-9][A-Z9-9][A-Z0-9]+" >final_exponentiation_v4.trace

ml_v3_addmod384=`grep ADDMOD384 miller_loop_v3.trace | wc -l`
ml_v3_submod384=`grep SUBMOD384 miller_loop_v3.trace | wc -l`
ml_v3_mulmod384=`grep MULMODMONT384 miller_loop_v3.trace | wc -l`
ml_v3_push16=`grep PUSH16 miller_loop_v3.trace | wc -l`
ml_v3_mem=`grep -E "MSTORE|MLOAD" miller_loop_v3.trace | wc -l`
ml_v3_others=`grep -vE "PUSH16|MSTORE|MLOAD|384" miller_loop_v3.trace | wc -l`

ml_v4_addmod384=`grep ADDMOD384 miller_loop_v4.trace | wc -l`
ml_v4_submod384=`grep SUBMOD384 miller_loop_v4.trace | wc -l`
ml_v4_mulmod384=`grep MULMODMONT384 miller_loop_v4.trace | wc -l`
ml_v4_push16=`grep PUSH16 miller_loop_v4.trace | wc -l`
ml_v4_mem=`grep -E "MSTORE|MLOAD" miller_loop_v4.trace | wc -l`
ml_v4_others=`grep -vE "PUSH16|MSTORE|MLOAD|384" miller_loop_v4.trace | wc -l`

echo "Paste to figure1.plt:"
echo "v7\\\_f2mul\\\_v3 $ml_v3_addmod384 $ml_v3_submod384 $ml_v3_mulmod384 $ml_v3_push16 $ml_v3_mem $ml_v3_others"
echo "v7\\\_f2mul\\\_v4 $ml_v4_addmod384 $ml_v4_submod384 $ml_v4_mulmod384 $ml_v4_push16 $ml_v4_mem $ml_v4_others"
echo "v9\\\_f2mul\\\_v3 $ml_v3_addmod384 $ml_v3_submod384 $ml_v3_mulmod384 0 $ml_v3_mem $ml_v3_others"
echo "v9\\\_f2mul\\\_v4 $ml_v4_addmod384 $ml_v4_submod384 $ml_v4_mulmod384 0 $ml_v4_mem $ml_v4_others"

fe_v3_addmod384=`grep ADDMOD384 final_exponentiation_v3.trace | wc -l`
fe_v3_submod384=`grep SUBMOD384 final_exponentiation_v3.trace | wc -l`
fe_v3_mulmod384=`grep MULMODMONT384 final_exponentiation_v3.trace | wc -l`
fe_v3_push16=`grep PUSH16 final_exponentiation_v3.trace | wc -l`
fe_v3_mem=`grep -E "MSTORE|MLOAD" final_exponentiation_v3.trace | wc -l`
fe_v3_others=`grep -vE "PUSH16|MSTORE|MLOAD|384" final_exponentiation_v3.trace | wc -l`

fe_v4_addmod384=`grep ADDMOD384 final_exponentiation_v4.trace | wc -l`
fe_v4_submod384=`grep SUBMOD384 final_exponentiation_v4.trace | wc -l`
fe_v4_mulmod384=`grep MULMODMONT384 final_exponentiation_v4.trace | wc -l`
fe_v4_push16=`grep PUSH16 final_exponentiation_v4.trace | wc -l`
fe_v4_mem=`grep -E "MSTORE|MLOAD" final_exponentiation_v4.trace | wc -l`
fe_v4_others=`grep -vE "PUSH16|MSTORE|MLOAD|384" final_exponentiation_v4.trace | wc -l`

echo "Paste to figure2.plt:"
echo "v7\\\_f2mul\\\_v3 $fe_v3_addmod384 $fe_v3_submod384 $fe_v3_mulmod384 $fe_v3_push16 $fe_v3_mem $fe_v3_others"
echo "v7\\\_f2mul\\\_v4 $fe_v4_addmod384 $fe_v4_submod384 $fe_v4_mulmod384 $fe_v4_push16 $fe_v4_mem $fe_v4_others"
echo "v9\\\_f2mul\\\_v3 $fe_v3_addmod384 $fe_v3_submod384 $fe_v3_mulmod384 0 $fe_v3_mem $fe_v3_others"
echo "v9\\\_f2mul\\\_v4 $fe_v4_addmod384 $fe_v4_submod384 $fe_v4_mulmod384 0 $fe_v4_mem $fe_v4_others"
