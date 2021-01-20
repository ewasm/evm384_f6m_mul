# Gas costs for miller loop on evm384-v7/v9 and f2mul_v3/v4
# Based on miller_loop_v3.hex and miller_loop_v4.hex

$data << EOD
v9\\_miller\\_loop\\_f2mul\\_v3 113718
v9\\_miller\\_loop\\_f2mul\\_v4 113718
v7\\_miller\\_loop\\_f2mul\\_v4 195129
v7\\_miller\\_loop\\_f2mul\\_v3 206223
EOD

set term png nocrop enhanced font "verdana,8"
set output "figure3.png"
set nokey
set boxwidth 0.5
set style fill solid
set xtics nomirror rotate by -45
set yrange[0:250000]
set ylabel "gas"
plot "$data" using 2:xtic(1) with boxes  lt rgb "#ff0000",\
  ""  using 0:($2+5000):(sprintf("%3i",$2)):(1) with labels notitle
# note: above line format is xval:ydata:boxwidth:color_index:xtic_labels
# note: 2 indicates column 2 is for y-coordinates
# note: xtic() is a function that is responsible for numbering/labeling the x-axis. xtic(1), therefore, indicates that we will be using column 1 of data.dat for labels.
