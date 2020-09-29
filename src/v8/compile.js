const path = require('path');
const fs = require('fs');

const { parser, compiler } = require('huff');

const pathToData = path.posix.resolve(__dirname, './');

const { inputMap, macros, jumptables } = parser.parseFile('f6m_mul_v8.huff', pathToData);

const {
    data: { bytecode: macroCode },
} = parser.processMacro('F6M_MUL_BENCH', 0, [], macros, inputMap, jumptables);

console.log("0x"+macroCode)

