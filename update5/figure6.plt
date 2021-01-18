# Future gas costs for final exponentiation on evm384-v7/v9 and f2mul_v3/v4
# Based on final_exponentiation_v3.hex and final_exponentiation_v4.hex

$data << EOD
v9\\_final\\_exp\\_f2mul\\_v3\\_fractional 126409
v9\\_final\\_exp\\_f2mul\\_v4\\_fractional 126409
v7\\_final\\_exp\\_f2mul\\_v4\\_fractional 166583
v7\\_final\\_exp\\_f2mul\\_v3\\_fractional 167798
v9\\_final\\_exp\\_f2mul\\_v4 175674
v9\\_final\\_exp\\_f2mul\\_v3 176349
v7\\_final\\_exp\\_f2mul\\_v4\\_potential 201908
v7\\_final\\_exp\\_f2mul\\_v3\\_potential 203933
v7\\_final\\_exp\\_f2mul\\_v4 309588
v7\\_final\\_exp\\_f2mul\\_v3 314313
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
