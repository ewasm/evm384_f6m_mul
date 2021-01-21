# Opcode counts for miller loop on evm384-v7/v9 and f2mul_v3/v4
# Based on miller_loop_v3.hex and miller_loop_v4.hex

# ADDMOD384 SUBMOD384 MULMODMONT384 PUSH16 MLOAD/MSTORE others
$data << EOD
miller\\_loop\\_f2mul\\_v3    12182    11786     6867
miller\\_loop\\_f2mul\\_v4    10333     8088     8716
final\\_exp\\_f2mul\\_v3    24370    13867     8196
final\\_exp\\_f2mul\\_v4    23695    12517     8871
EOD

set term png nocrop enhanced font "monospace,12"  size 1200,512
set output 'figure1_v3_vs_v4.png'
set auto x
set boxwidth 1
set style fill solid 1.00
set style histogram clustered gap 1
set yrange [0:50000]
plot "$data" u 2:xtic(1) with histogram title "ADDMOD384",\
     "$data" u 3 with histogram title "SUBMOD384",\
     "$data" u 4 with histogram title "MULMODMON384",\
     "$data" u 0:2:2 with labels font "monospace,12" offset -5.5,0.8 title " ",\
     "$data" u 0:3:3 with labels font "monospace,12" offset 0,0.8 title " ",\
     "$data" u 0:4:4 with labels font "monospace,12" offset 5.5,0.8 title " "
