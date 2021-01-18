# Gas costs for final exponentiation on evm384-v7/v9 and f2mul_v3/v4
# Based on final_exponentiation_hard_coded_test_f2mulv3.hex and final_exponentiation_hard_coded_test_f2mulv4.hex

$data << EOD
v9\\_final\\_exp\\_f2mulv3\\_potential 127208
v9\\_final\\_exp\\_f2mulv4\\_potential 128018
v7\\_final\\_exp\\_f2mulv4\\_potential 163729
v7\\_final\\_exp\\_f2mulv3\\_potential 163999
v9\\_final\\_exp\\_f2mulv4 175823
v9\\_final\\_exp\\_f2mulv3 176498
v7\\_final\\_exp\\_f2mulv4\\_PUSH2 256660
v7\\_final\\_exp\\_f2mulv3\\_PUSH2 260035
v7\\_final\\_exp\\_f2mulv4 309737
v7\\_final\\_exp\\_f2mulv3 314462
EOD

set term png nocrop enhanced font "verdana,8"
set output "figure4.png"
set nokey
set boxwidth 0.5
set style fill solid
set xtics nomirror rotate by -45
set yrange[0:350000]
set ylabel "gas"
plot "$data" using 2:xtic(1) with boxes  lt rgb "#ff0000",\
  ""  using 0:($2+8000):(sprintf("%3i",$2)):(1) with labels notitle
# note: above line format is xval:ydata:boxwidth:color_index:xtic_labels
# note: 2 indicates column 2 is for y-coordinates
# note: xtic() is a function that is responsible for numbering/labeling the x-axis. xtic(1), therefore, indicates that we will be using column 1 of data.dat for labels.
