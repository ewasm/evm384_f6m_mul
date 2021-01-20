# Future gas costs for final exponentiation on evm384-v7/v9 and f2mul_v3/v4
# Based on final_exponentiation_v3.hex and final_exponentiation_v4.hex

$data << EOD
v9\\_final\\_exp\\_f2mul\\_v3\\_fractional 126465
v9\\_final\\_exp\\_f2mul\\_v4\\_fractional 126465
v7\\_final\\_exp\\_f2mul\\_v4\\_fractional 166639
v7\\_final\\_exp\\_f2mul\\_v3\\_fractional 167854
v9\\_final\\_exp\\_f2mul\\_v3 184601
v9\\_final\\_exp\\_f2mul\\_v4 184601
v7\\_final\\_exp\\_f2mul\\_v4\\_potential 201964
v7\\_final\\_exp\\_f2mul\\_v3\\_potential 203989
v7\\_final\\_exp\\_f2mul\\_v4 318515
v7\\_final\\_exp\\_f2mul\\_v3 322565
EOD

set term png nocrop enhanced font "monospace,8"
set output "figure6.png"
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
