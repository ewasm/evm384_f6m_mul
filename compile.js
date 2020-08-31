const path = require('path');
const fs = require('fs');

const { compiler } = require('./huff/src');
const parser = require('./huff/src/parser');

const pathToData = path.posix.resolve(__dirname, './');

const { inputMap, macros, jumptables } = parser.parseFile('f2m_mul.huff', pathToData);

const {
    data: { bytecode: macroCode },
//} = parser.processMacro('F2M_MUL_TESTER_CALLDATA', 0, [], macros, inputMap, jumptables);
} = parser.processMacro('F2M_MUL_BENCHER', 0, [], macros, inputMap, jumptables);

console.log("0x"+macroCode)

