# Gas costs for miller loop on evm384-v7/v9 and f2mul_v3/v4
# Based on miller_loop_hard_coded_test_f2mulv3.hex and miller_loop_hard_coded_test_f2mulv4.hex

$data << EOD
v9\\_miller\\_loop\\_f2mulv3\\_potential 80214
v9\\_miller\\_loop\\_f2mulv4\\_potential 82433
v7\\_miller\\_loop\\_f2mulv4\\_potential 104143
v7\\_miller\\_loop\\_f2mulv3\\_potential 104882
v9\\_miller\\_loop\\_f2mulv4 105041
v9\\_miller\\_loop\\_f2mulv3 106890
v7\\_miller\\_loop\\_f2mulv4\\_PUSH2 155788
v7\\_miller\\_loop\\_f2mulv3\\_PUSH2 165033
v7\\_miller\\_loop\\_f2mulv4 186452
v7\\_miller\\_loop\\_f2mulv3 199395
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
