const path = require('path');
const fs = require('fs');

const { parser, compiler } = require('huff');
//const parser = require('huff/src');

const pathToData = path.posix.resolve(__dirname, './');

// uncomment a one file and one macro name below

//const { inputMap, macros, jumptables } = parser.parseFile('f6m_mul_v2.huff', pathToData);
//const { inputMap, macros, jumptables } = parser.parseFile('f6m_mul_v4.huff', pathToData);
const { inputMap, macros, jumptables } = parser.parseFile('f6m_mul_v7.huff', pathToData);

const {
    data: { bytecode: macroCode },
} = parser.processMacro('F6M_MUL_BENCH', 0, [], macros, inputMap, jumptables);
//} = parser.processMacro('F6M_MUL_BENCH', 0, [], macros, inputMap, jumptables);

console.log("0x"+macroCode)

