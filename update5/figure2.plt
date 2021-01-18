# Opcode counts for final exponentiation on evm384-v7/v9 and f2mul_v3/v4
# Based on final_exponentiation_v3.hex and final_exponentiation_v4.hex

# ADDMOD384 SUBMOD384 MULMODMONT384 PUSH16 MLOAD/MSTORE others
$data << EOD
v7\\_f2mul\\_v3    24370    13867     8196    45988     7259    10746
v7\\_f2mul\\_v4    23695    12517     8871    44638     7259    10746
v9\\_f2mul\\_v3    24370    13867     8196 0     7259    10746
v9\\_f2mul\\_v4    23695    12517     8871 0     7259    10746
EOD

set term png nocrop enhanced font "monospace,12"  size 1500,512
set output 'figure2.png'
set auto x
set boxwidth 1
set style fill solid 1.00
set style histogram clustered gap 1
set yrange [0:70000]
plot "$data" u 2:xtic(1) with histogram title "ADDMOD384",\
     "$data" u 3 with histogram title "SUBMOD384",\
     "$data" u 4 with histogram title "MULMODMON384",\
     "$data" u 5 with histogram title "PUSH16",\
     "$data" u 6 with histogram title "MLOAD/MSTORE",\
     "$data" u 7 with histogram title "others",\
     "$data" u 0:2:2 with labels font "monospace,11" offset -10,0.8 title " ",\
     "$data" u 0:3:3 with labels font "monospace,11" offset -5.8,0.8 title " ",\
     "$data" u 0:4:4 with labels font "monospace,11" offset -2,0.8 title " ",\
     "$data" u 0:5:5 with labels font "monospace,11" offset 2,0.8 title " ",\
     "$data" u 0:6:6 with labels font "monospace,11" offset 6,0.8 title " ",\
     "$data" u 0:7:7 with labels font "monospace,11" offset 10,0.8 title " "
