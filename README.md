# get this gist, note: directory must be next to huff since paths to huff are hard-coded
git clone https://gist.github.com/poemm/ f2m_mul_huff
cd f2m_mul_huff

# set up huff
git clone https://github.com/AztecProtocol/huff.git
# patch huff with new opcodes
#diff -ruN huff huff_modified > huff.patch
patch -s -p0 < huff.patch
# get dependencies in huff/package.json, (everything is local to the created dir node_modules)
cd huff
npm install     # note: npm caches packages in /home/<user>/.npm. To remove cache: npm cache clean
cd ..

# generate code to build.js
node compile.js
