# Opcode counts for final exponentiation on evm384-v7/v9 and f2mul_v3/v4
# Based on final_exponentiation_hard_coded_test_f2mulv3.hex and final_exponentiation_hard_coded_test_f2mulv4.hex

$data << EOD
v7\\\_f2mulv3 24370 13867 8196 64358
v7\\\_f2mulv4 23695 12517 8871 63008
v9\\\_f2mulv3 24370 13867 8196 17925
v9\\\_f2mulv4 23695 12517 8871 17925
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
     "$data" u 5 with histogram title "non-EVM384",\
     "$data" u 0:2:2 with labels font "monospace,12" offset -7.3,0.5 title " ",\
     "$data" u 0:3:3 with labels font "monospace,12" offset -2.3,0.5 title " ",\
     "$data" u 0:4:4 with labels font "monospace,12" offset 2.7,0.5 title " ",\
     "$data" u 0:5:5 with labels font "monospace,12" offset 7.7,0.5 title " "
