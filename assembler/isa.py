instruction_table = {
    # 2 operand instructions
    # 11 bits and need to be extended with 5 more bits
    'add':['00011','Rscr','Rdst'],
    'sub':['00100','Rscr','Rdst'],
    'and':['00101','Rscr','Rdst'],
    'or' :['00111','Rscr','Rdst'],
    'mov':['10000','Rscr','Rdst'],
    'ldd':['10010','Rscr','Rdst'],
    'std':['10011','Rscr','Rdst'],

    # special instructions because the second operand is immediate value
    # 8 bits at least and need to be to 16 bits
    'ldm':['10001','Rdst','imm'],
    'shl':['10100','Rscr','imm'],
    'shl':['10101','Rscr','imm'],
    
    # 1 operand instructions
    # 8 bits and need to extended with 8 bits
    'not': ['00000','Rdst'],
    'inc':['00001','Rdst'],
    'dec':['00010','Rdst'],
    'out': ['01011','Rdst'],
    'in':['01100','Rdst'],
    'push':['01101','Rdst'],
    'pop':['01110','Rdst'],
    'jz':['11000','Rdst'],
    'jn':['11001','Rdst'],
    'jc':['11010','Rdst'],
    'jmp':['11011','Rdst'],
    
    # zero operand instructions
    # 8 bits and need to extended with 11 bits
    'nop':['01000'],
    'setc':['01001'],
    'clrc':['01010'],
    'call':['11100'],
    'ret':['11101'],
}

reg_table = {
    'r0':'000',
    'r1':'001',
    'r2':'010',
    'r3':'011',
    'r4':'100',
    'r5':'101',
    'r6':'110',
    'r7':'111'    
}