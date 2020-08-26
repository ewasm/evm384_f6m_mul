get this gist
```
git clone https://gist.github.com/bf50b9c8f18c33c0883461ede3a4ae8a.git f2m_mul_huff
cd f2m_mul_huff
```

get huff, note: put huff here because path to huff is hardcoded in compile.js
```
git clone https://github.com/AztecProtocol/huff.git
```

patch huff with new opcodes
```
#diff -ruN huff huff_modified > huff.patch
patch -s -p0 < huff.patch
```

get dependencies listed in huff/package.json, (don't worry, everything is local to the created dir node_modules, can just delete this dir)
```
cd huff
npm install	# note: npm caches packages in /home/<user>/.npm. To remove cache: npm cache clean
cd ..
```

finally generate evm code
```
node compile.js
```
