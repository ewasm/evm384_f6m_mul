# Files

```
f6m_mul_v2.huff	        huff source code using interface v2
f6m_mul_v4.huff	        huff source code using interface v4
f6m_mul_v6.huff         huff source code using interface v6
f6m_mul_v7.huff         huff source code using interface v7

f6m_mul_v2.json         Ethereum test file with v2 test bytecode under the field "code"
f6m_mul_v4.json	        Ethereum test file with v4 test bytecode under the field "code"
f6m_mul_v6.json         Ethereum test file with v6 test bytecode under the field "code"
f6m_mul_v7.json         Ethereum test file with v7 test bytecode under the field "code"

f6m_mul_v2_bench.json   Ethereum test file with v2 benchmark bytecode under the field "code"
f6m_mul_v4_bench.json   Ethereum test file with v4 benchmark bytecode under the field "code"
f6m_mul_v6_bench.json   Ethereum test file with v6 benchmark bytecode under the field "code"
f6m_mul_v7_bench.json   Ethereum test file with v7 benchmark bytecode under the field "code"

huff.patch              patch to tell huff how to handle evm384 opcodes
```

# Compile

get this directory
```
git clone https://gist.github.com/bf50b9c8f18c33c0883461ede3a4ae8a.git f6m_mul_huff
cd f6m_mul_huff
```

get huff, note: put huff inside the directory `f6m_mul_huff` because the path to huff is hardcoded in `compile.js`
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

finally generate the f6m_mul evm bytecode
```
node compile.js
```
