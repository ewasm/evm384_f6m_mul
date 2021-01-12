# run: python3 gascosts_calculator.py

# this file is used to calculate gas costs for EVM384 update 5.
# TODO: opcode counts are slightly off because input now uses calldatacopy, not hard-coded
# TODO: calldata cost is currently hard-coded for miller loop, should add switch for final exponentiation, but this is small anyway

# function from yellowpaper to give gas cost for memory growth
def Cmem(memsize): 
  a = (memsize+32)//32
  return 3*a+(a**2)//512

opcode_costs = {
 'PUSH': 3,
 'ADDMOD384': 2,
 'SUBMOD384': 2,
 'MULMODMONT384': 5,
 'MSTORE': 3,
 'MLOAD': 3,
 'JUMPDEST': 1,
 'JUMPI': 10,
 'JUMP': 8,
 'SUB': 3,
 'LT': 3,
 'AND': 3,
 'XOR': 3,
 'SHR': 3,
 'DUP': 3,
 'SWAP': 3,
 'POP': 2,
 'CALLDATACOPY': 3,
 'RETURN': 0,
 'other': 0}

opcode_costs_PUSH2 = {key: value for key, value in opcode_costs.items()}
opcode_costs_PUSH2['PUSH']=2

opcode_costs_potential = {key: value for key, value in opcode_costs.items()}
opcode_costs_potential['ADDMOD384']=1.3
opcode_costs_potential['SUBMOD384']=1.2
opcode_costs_potential['MULMODMONT384']=4.9
opcode_costs_potential['PUSH']=0.8
opcode_costs_potential['DUP']=0.8

def gas_cost(memory_length, opcode_counts, opcode_costs, no_PUSH16_flag):
  calldata_length_miller_loop = 288
  calldata_length_final_exponentiation = 576
  calldata_cost_miller_loop = calldata_length_miller_loop//32 + 0 if calldata_length_miller_loop%32 else 1
  calldata_cost_final_exponentiation = calldata_length_final_exponentiation//32 + 0 if calldata_length_final_exponentiation%32 else 1
  gas_cost=0
  gas_cost+=Cmem(memory_length)
  gas_cost+=calldata_cost_miller_loop   # TODO: add flag
  for op in opcode_counts:
    if op[:3]=='DUP':
      gas_cost+=opcode_costs['DUP']*opcode_counts[op]
    elif op[:4] == 'PUSH':
      if op=='PUSH16' and no_PUSH16_flag:
        pass
      else:
        gas_cost+=opcode_costs['PUSH']*opcode_counts[op]
    elif op[:4] == 'SWAP':
      gas_cost+=opcode_costs['SWAP']*opcode_counts[op]
    else:
      gas_cost+=opcode_costs[op]*opcode_counts[op]
  return int(gas_cost)



###################
# MILLER LOOP COSTS

memory_length_miller_loop_f2mulv3=15712
opcode_counts_miller_loop_f2mulv3={'PUSH16': 30835, 'ADDMOD384': 12182, 'SUBMOD384': 11786, 'MULMODMONT384': 6867, 'PUSH2': 3202, 'MSTORE': 1545, 'MLOAD': 1532, 'PUSH1': 250, 'JUMPDEST': 129, 'JUMPI': 124, 'SUB': 62, 'LT': 62, 'AND': 62, 'XOR': 62, 'SHR': 62, 'PUSH8': 62, 'DUP1': 62, 'DUP2': 62, 'SWAP1': 62, 'PUSH32': 13, 'POP': 1, 'RETURN': 1, 'other': 0}
data = {}
data.update({
 "v7\\\\_miller\\\\_loop\\\\_f2mulv3": gas_cost(memory_length_miller_loop_f2mulv3,opcode_counts_miller_loop_f2mulv3,opcode_costs,0),
 "v7\\\\_miller\\\\_loop\\\\_f2mulv3\\\\_PUSH2": gas_cost(memory_length_miller_loop_f2mulv3,opcode_counts_miller_loop_f2mulv3,opcode_costs_PUSH2,0),
 "v7\\\\_miller\\\\_loop\\\\_f2mulv3\\\\_potential": gas_cost(memory_length_miller_loop_f2mulv3,opcode_counts_miller_loop_f2mulv3,opcode_costs_potential,0),
 "v9\\\\_miller\\\\_loop\\\\_f2mulv3": gas_cost(memory_length_miller_loop_f2mulv3,opcode_counts_miller_loop_f2mulv3,opcode_costs,1),
 "v9\\\\_miller\\\\_loop\\\\_f2mulv3\\\\_potential": gas_cost(memory_length_miller_loop_f2mulv3,opcode_counts_miller_loop_f2mulv3,opcode_costs_potential,1),
 })

memory_length_miller_loop_f2mulv4=15712
opcode_counts_miller_loop_f2mulv4={'PUSH16': 27137, 'ADDMOD384': 10333, 'MULMODMONT384': 8716, 'SUBMOD384': 8088, 'PUSH2': 3202, 'MSTORE': 1545, 'MLOAD': 1532, 'PUSH1': 250, 'JUMPDEST': 129, 'JUMPI': 124, 'SUB': 62, 'LT': 62, 'AND': 62, 'XOR': 62, 'SHR': 62, 'PUSH8': 62, 'DUP1': 62, 'DUP2': 62, 'SWAP1': 62, 'PUSH32': 13, 'POP': 1, 'RETURN': 1, 'other': 0}
data.update({
 "v7\\\\_miller\\\\_loop\\\\_f2mulv4": gas_cost(memory_length_miller_loop_f2mulv4,opcode_counts_miller_loop_f2mulv4,opcode_costs,0),
 "v7\\\\_miller\\\\_loop\\\\_f2mulv4\\\\_PUSH2": gas_cost(memory_length_miller_loop_f2mulv4,opcode_counts_miller_loop_f2mulv4,opcode_costs_PUSH2,0),
 "v7\\\\_miller\\\\_loop\\\\_f2mulv4\\\\_potential": gas_cost(memory_length_miller_loop_f2mulv4,opcode_counts_miller_loop_f2mulv4,opcode_costs_potential,0),
 "v9\\\\_miller\\\\_loop\\\\_f2mulv4": gas_cost(memory_length_miller_loop_f2mulv4,opcode_counts_miller_loop_f2mulv4,opcode_costs,1),
 "v9\\\\_miller\\\\_loop\\\\_f2mulv4\\\\_potential": gas_cost(memory_length_miller_loop_f2mulv4,opcode_counts_miller_loop_f2mulv4,opcode_costs_potential,1),
 })

for k in sorted(data, key=data.get, reverse=False):
  print(k, data[k])



#################
# FINAL EXP COSTS

memory_length_final_exp_f2mulv3=15424
opcode_counts_final_exp_f2mulv3={'PUSH16': 45988, 'ADDMOD384': 24370, 'SUBMOD384': 13867, 'MULMODMONT384': 8196, 'PUSH2': 7571, 'MSTORE': 3667, 'MLOAD': 3610, 'PUSH1': 829, 'JUMPDEST': 421, 'DUP1': 367, 'SUB': 315, 'LT': 315, 'JUMPI': 315, 'SWAP1': 315, 'DUP9': 312, 'JUMP': 141, 'PUSH32': 39, 'POP': 35, 'DUP7': 34, 'DUP6': 22, 'DUP2': 18, 'DUP5': 15, 'DUP4': 12, 'DUP3': 11, 'DUP8': 5, 'RETURN': 1, 'other': 0}
data = {}
data.update({
 "v7\\\\_final\\\\_exp\\\\_f2mulv3": gas_cost(memory_length_final_exp_f2mulv3,opcode_counts_final_exp_f2mulv3,opcode_costs,0),
 "v7\\\\_final\\\\_exp\\\\_f2mulv3\\\\_PUSH2": gas_cost(memory_length_final_exp_f2mulv3,opcode_counts_final_exp_f2mulv3,opcode_costs_PUSH2,0),
 "v7\\\\_final\\\\_exp\\\\_f2mulv3\\\\_potential": gas_cost(memory_length_final_exp_f2mulv3,opcode_counts_final_exp_f2mulv3,opcode_costs_potential,0),
 "v9\\\\_final\\\\_exp\\\\_f2mulv3": gas_cost(memory_length_final_exp_f2mulv3,opcode_counts_final_exp_f2mulv3,opcode_costs,1),
 "v9\\\\_final\\\\_exp\\\\_f2mulv3\\\\_potential": gas_cost(memory_length_final_exp_f2mulv3,opcode_counts_final_exp_f2mulv3,opcode_costs_potential,1),
  })

memory_length_final_exp_f2mulv4=15424
opcode_counts_final_exp_f2mulv4={'PUSH16': 44638, 'ADDMOD384': 23695, 'SUBMOD384': 12517, 'MULMODMONT384': 8871, 'PUSH2': 7571, 'MSTORE': 3667, 'MLOAD': 3610, 'PUSH1': 829, 'JUMPDEST': 421, 'DUP1': 367, 'SUB': 315, 'LT': 315, 'JUMPI': 315, 'SWAP1': 315, 'DUP9': 312, 'JUMP': 141, 'PUSH32': 39, 'POP': 35, 'DUP7': 34, 'DUP6': 22, 'DUP2': 18, 'DUP5': 15, 'DUP4': 12, 'DUP3': 11, 'DUP8': 5, 'RETURN': 1, 'other': 0}
data.update({
 "v7\\\\_final\\\\_exp\\\\_f2mulv4": gas_cost(memory_length_final_exp_f2mulv4,opcode_counts_final_exp_f2mulv4,opcode_costs,0),
 "v7\\\\_final\\\\_exp\\\\_f2mulv4\\\\_PUSH2": gas_cost(memory_length_final_exp_f2mulv4,opcode_counts_final_exp_f2mulv4,opcode_costs_PUSH2,0),
 "v7\\\\_final\\\\_exp\\\\_f2mulv4\\\\_potential": gas_cost(memory_length_final_exp_f2mulv4,opcode_counts_final_exp_f2mulv4,opcode_costs_potential,0),
 "v9\\\\_final\\\\_exp\\\\_f2mulv4": gas_cost(memory_length_final_exp_f2mulv4,opcode_counts_final_exp_f2mulv4,opcode_costs,1),
 "v9\\\\_final\\\\_exp\\\\_f2mulv4\\\\_potential": gas_cost(memory_length_final_exp_f2mulv4,opcode_counts_final_exp_f2mulv4,opcode_costs_potential,1),
  })


for k in sorted(data, key=data.get, reverse=False):
  print(k, data[k])
