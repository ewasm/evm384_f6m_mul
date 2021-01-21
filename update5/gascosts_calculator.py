# run: python3 gascosts_calculator.py

# Originally from https://gist.github.com/poemm/396917e85af87ce7b550c53986883762

# this file is used to calculate gas costs for EVM384 update 5.
# Note: gas costs calculated here are off of evmone by like 21 gas, very small error

# function from yellowpaper to give gas cost for memory growth


def Cmem(memsize):
  a = (memsize+32)//32
  return 3*a+(a**2)//512

opcode_costs = {
 'PUSH': 3, 
 'ADDMOD384': 2, 
 'SUBMOD384': 2, 
 'MULMODMONT384': 6,
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
 'RETURN': 0
}

modela = opcode_costs.copy()
modela['ADDMOD384']=2
modela['SUBMOD384']=2
modela['MULMODMONT384']=6
modela['PUSH']=3
modela['DUP']=3
modela['MSTORE']=3
modela['MLOAD']=3

modela_pushdup2 = modela.copy()
modela_pushdup2['PUSH']=2
modela_pushdup2['DUP']=2

modela_repriced = modela.copy()
modela_repriced['ADDMOD384']=2
modela_repriced['SUBMOD384']=2
modela_repriced['MULMODMONT384']=5
modela_repriced['PUSH']=1
modela_repriced['DUP']=1
modela_repriced['MSTORE']=1
modela_repriced['MLOAD']=1

modela_fractional = modela.copy()
modela_fractional['ADDMOD384']=1.1
modela_fractional['SUBMOD384']=1.1
modela_fractional['MULMODMONT384']=5
modela_fractional['PUSH']=0.9
modela_fractional['DUP']=0.7
modela_fractional['MSTORE']=0.8
modela_fractional['MLOAD']=1

modelb = opcode_costs.copy()
modelb['ADDMOD384']=1
modelb['SUBMOD384']=1
modelb['MULMODMONT384']=3
modelb['PUSH']=3
modelb['DUP']=3
modelb['MSTORE']=3
modelb['MLOAD']=3

modelb_pushdup2 = modelb.copy()
modelb_pushdup2['PUSH']=2
modelb_pushdup2['DUP']=2

modelb_repriced = modelb.copy()
modelb_repriced['ADDMOD384']=1
modelb_repriced['SUBMOD384']=1
modelb_repriced['MULMODMONT384']=3
modelb_repriced['PUSH']=1
modelb_repriced['DUP']=1
modelb_repriced['MSTORE']=1
modelb_repriced['MLOAD']=1

modelb_fractional = modelb.copy()
modelb_fractional['ADDMOD384']=0.8
modelb_fractional['SUBMOD384']=0.7
modelb_fractional['MULMODMONT384']=3
modelb_fractional['PUSH']=0.9
modelb_fractional['DUP']=0.7
modelb_fractional['MSTORE']=0.8
modelb_fractional['MLOAD']=1

# the main function to compute gas costs
def gas_cost(memory_length, opcode_counts, opcode_costs, no_PUSH16_flag, miller_or_finalexp_flag):
  gas_cost=0
  gas_cost+=Cmem(memory_length)
  if miller_or_finalexp_flag:
    calldata_length = 288
  else:
    calldata_length = 576
  calldatacopy_cost = calldata_length//32 + (0 if calldata_length%32 else 1)
  gas_cost+=calldatacopy_cost*3
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


memory_length_miller_loop_f2mul_v3=15712
opcode_counts_miller_loop_f2mul_v3={'PUSH16': 30835, 'ADDMOD384': 12182, 'SUBMOD384': 11786, 'MULMODMONT384': 6867, 'PUSH2': 3181, 'MSTORE': 1536, 'MLOAD': 1532, 'PUSH1': 265, 'JUMPDEST': 129, 'JUMPI': 124, 'SUB': 62, 'LT': 62, 'AND': 62, 'XOR': 62, 'SHR': 62, 'PUSH8': 62, 'DUP1': 62, 'DUP2': 62, 'SWAP1': 62, 'PUSH32': 4, 'CALLDATACOPY': 1, 'POP': 1, 'RETURN': 1}
data = {}
data.update({
 "v7\\\\_modela": gas_cost(memory_length_miller_loop_f2mul_v3,opcode_counts_miller_loop_f2mul_v3,modela,0,1),
 "v7\\\\_modela\\\\_pushdup2": gas_cost(memory_length_miller_loop_f2mul_v3,opcode_counts_miller_loop_f2mul_v3,modela_pushdup2,0,1),
 "v7\\\\_modela\\\\_repriced": gas_cost(memory_length_miller_loop_f2mul_v3,opcode_counts_miller_loop_f2mul_v3,modela_repriced,0,1),
 "v7\\\\_modela\\\\_fractional": gas_cost(memory_length_miller_loop_f2mul_v3,opcode_counts_miller_loop_f2mul_v3,modela_fractional,0,1),
 "v9\\\\_modela": gas_cost(memory_length_miller_loop_f2mul_v3,opcode_counts_miller_loop_f2mul_v3,modela,1,1),
 "v9\\\\_modela\\\\_pushdup2": gas_cost(memory_length_miller_loop_f2mul_v3,opcode_counts_miller_loop_f2mul_v3,modela_pushdup2,1,1),
 "v9\\\\_modela\\\\_repriced": gas_cost(memory_length_miller_loop_f2mul_v3,opcode_counts_miller_loop_f2mul_v3,modela_repriced,1,1),
 "v9\\\\_modela\\\\_fractional": gas_cost(memory_length_miller_loop_f2mul_v3,opcode_counts_miller_loop_f2mul_v3,modela_fractional,1,1),
 "v7\\\\_modelb": gas_cost(memory_length_miller_loop_f2mul_v3,opcode_counts_miller_loop_f2mul_v3,modelb,0,1),
 "v7\\\\_modelb\\\\_pushdup2": gas_cost(memory_length_miller_loop_f2mul_v3,opcode_counts_miller_loop_f2mul_v3,modelb_pushdup2,0,1),
 "v7\\\\_modelb\\\\_repriced": gas_cost(memory_length_miller_loop_f2mul_v3,opcode_counts_miller_loop_f2mul_v3,modelb_repriced,0,1),
 "v7\\\\_modelb\\\\_fractional": gas_cost(memory_length_miller_loop_f2mul_v3,opcode_counts_miller_loop_f2mul_v3,modelb_fractional,0,1),
 "v9\\\\_modelb": gas_cost(memory_length_miller_loop_f2mul_v3,opcode_counts_miller_loop_f2mul_v3,modelb,1,1),
 "v9\\\\_modelb\\\\_pushdup2": gas_cost(memory_length_miller_loop_f2mul_v3,opcode_counts_miller_loop_f2mul_v3,modelb_pushdup2,1,1),
 "v9\\\\_modelb\\\\_repriced": gas_cost(memory_length_miller_loop_f2mul_v3,opcode_counts_miller_loop_f2mul_v3,modelb_repriced,1,1),
 "v9\\\\_modelb\\\\_fractional": gas_cost(memory_length_miller_loop_f2mul_v3,opcode_counts_miller_loop_f2mul_v3,modelb_fractional,1,1),
 })

# v4 costs are dropped for now
#memory_length_miller_loop_f2mul_v4=15712
#opcode_counts_miller_loop_f2mul_v4={'PUSH16': 27137, 'ADDMOD384': 10333, 'MULMODMONT384': 8716, 'SUBMOD384': 8088, 'PUSH2': 3181, 'MSTORE': 1536, 'MLOAD': 1532, 'PUSH1': 265, 'JUMPDEST': 129, 'JUMPI': 124, 'SUB': 62, 'LT': 62, 'AND': 62, 'XOR': 62, 'SHR': 62, 'PUSH8': 62, 'DUP1': 62, 'DUP2': 62, 'SWAP1': 62, 'PUSH32': 4, 'CALLDATACOPY': 1, 'POP': 1, 'RETURN': 1}

print("For figure2_miller_loop.plt:")
for k in sorted(data, key=data.get, reverse=False):
  print(k, data[k])


memory_length_final_exp_f2mul_v3=15424
opcode_counts_final_exp_f2mul_v3={'PUSH16': 45988, 'ADDMOD384': 24370, 'SUBMOD384': 13867, 'MULMODMONT384': 8196, 'PUSH2': 7546, 'MSTORE': 3649, 'MLOAD': 3610, 'PUSH1': 839, 'JUMPDEST': 421, 'DUP1': 367, 'SUB': 315, 'LT': 315, 'JUMPI': 315, 'SWAP1': 315, 'DUP9': 312, 'JUMP': 141, 'POP': 35, 'DUP7': 34, 'DUP6': 22, 'PUSH32': 21, 'DUP2': 18, 'DUP5': 15, 'DUP4': 12, 'DUP3': 11, 'DUP8': 5, 'CALLDATACOPY': 1, 'RETURN': 1}
data = {}
data.update({
 "v7\\\\_modela": gas_cost(memory_length_final_exp_f2mul_v3,opcode_counts_final_exp_f2mul_v3,modela,0,1),
 "v7\\\\_modela\\\\_pushdup2": gas_cost(memory_length_final_exp_f2mul_v3,opcode_counts_final_exp_f2mul_v3,modela_pushdup2,0,1),
 "v7\\\\_modela\\\\_repriced": gas_cost(memory_length_final_exp_f2mul_v3,opcode_counts_final_exp_f2mul_v3,modela_repriced,0,1),
 "v7\\\\_modela\\\\_fractional": gas_cost(memory_length_final_exp_f2mul_v3,opcode_counts_final_exp_f2mul_v3,modela_fractional,0,1),
 "v9\\\\_modela": gas_cost(memory_length_final_exp_f2mul_v3,opcode_counts_final_exp_f2mul_v3,modela,1,1),
 "v9\\\\_modela\\\\_pushdup2": gas_cost(memory_length_final_exp_f2mul_v3,opcode_counts_final_exp_f2mul_v3,modela_pushdup2,1,1),
 "v9\\\\_modela\\\\_repriced": gas_cost(memory_length_final_exp_f2mul_v3,opcode_counts_final_exp_f2mul_v3,modela_repriced,1,1),
 "v9\\\\_modela\\\\_fractional": gas_cost(memory_length_final_exp_f2mul_v3,opcode_counts_final_exp_f2mul_v3,modela_fractional,1,1),
 "v7\\\\_modelb": gas_cost(memory_length_final_exp_f2mul_v3,opcode_counts_final_exp_f2mul_v3,modelb,0,1),
 "v7\\\\_modelb\\\\_pushdup2": gas_cost(memory_length_final_exp_f2mul_v3,opcode_counts_final_exp_f2mul_v3,modelb_pushdup2,0,1),
 "v7\\\\_modelb\\\\_repriced": gas_cost(memory_length_final_exp_f2mul_v3,opcode_counts_final_exp_f2mul_v3,modelb_repriced,0,1),
 "v7\\\\_modelb\\\\_fractional": gas_cost(memory_length_final_exp_f2mul_v3,opcode_counts_final_exp_f2mul_v3,modelb_fractional,0,1),
 "v9\\\\_modelb": gas_cost(memory_length_final_exp_f2mul_v3,opcode_counts_final_exp_f2mul_v3,modelb,1,1),
 "v9\\\\_modelb\\\\_pushdup2": gas_cost(memory_length_final_exp_f2mul_v3,opcode_counts_final_exp_f2mul_v3,modelb_pushdup2,1,1),
 "v9\\\\_modelb\\\\_repriced": gas_cost(memory_length_final_exp_f2mul_v3,opcode_counts_final_exp_f2mul_v3,modelb_repriced,1,1),
 "v9\\\\_modelb\\\\_fractional": gas_cost(memory_length_final_exp_f2mul_v3,opcode_counts_final_exp_f2mul_v3,modelb_fractional,1,1),
 })

# v4 costs are dropped for now
memory_length_final_exp_f2mul_v4=15424
opcode_counts_final_exp_f2mul_v4={'PUSH16': 44638, 'ADDMOD384': 23695, 'SUBMOD384': 12517, 'MULMODMONT384': 8871, 'PUSH2': 7546, 'MSTORE': 3649, 'MLOAD': 3610, 'PUSH1': 839, 'JUMPDEST': 421, 'DUP1': 367, 'SUB': 315, 'LT': 315, 'JUMPI': 315, 'SWAP1': 315, 'DUP9': 312, 'JUMP': 141, 'POP': 35, 'DUP7': 34, 'DUP6': 22, 'PUSH32': 21, 'DUP2': 18, 'DUP5': 15, 'DUP4': 12, 'DUP3': 11, 'DUP8': 5, 'CALLDATACOPY': 1, 'RETURN': 1}

print("For figure3_final_exp.plt:")
for k in sorted(data, key=data.get, reverse=False):
  print(k, data[k])
