A generator for huff code for parts of BLS12-381 pairing and scalar multiplication.

# Files

```
main.huff		huff source which sets up memory and calls the miller loop
miller_loop.huff	huff source for miller loop, generated by gen.py
gen.py			encodes the algorithms and outputs huff code to execute the algorithms
miller_loop_bench.json  Ethereum test file, with benchmark bytecode under the field "code"

compile.js              calls the huff compiler
huff.patch              patch to tell huff how to handle evm384 opcodes
```

# Compile

get this directory
```
git clone https://gist.github.com/bf50b9c8f18c33c0883461ede3a4ae8a.git evm384_miller_loop
cd evm384_miller_loop
```

get huff, note: put huff inside the directory `evm384_miller_loop` because the path to huff is hardcoded in `compile.js`
```
git clone https://github.com/AztecProtocol/huff.git
```

patch huff with new opcodes
```
#diff -ruN huff huff_modified > huff.patch
patch -s -p0 < huff.patch
```

get dependencies listed in `huff/package.json`, (don't worry, everything is local to the created dir `node_modules/`, can just delete this dir)
```
cd huff
npm install	# note: npm caches packages in /home/<user>/.npm. To remove cache: npm cache clean
cd ..
```

finally generate the evm bytecode for miller loop benchmark
```
python3 gen.py > miller_loop.huff
node compile.js > miller_loop.hex
```
