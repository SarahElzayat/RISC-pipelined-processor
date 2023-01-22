compilersol = {
    # need two operands rscr and rdst
    # first and second
    'add':['1'],        #,'Rscr','Rdst'],
    'sub':['1'],        #,'Rscr','Rdst'],
    'and':['1'],        #,'Rscr','Rdst'],
    'or' :['1'],        #,'Rscr','Rdst'],
    'ldd':['1'],        #,'Rscr','Rdst'],
    'std':['1'],        #,'Rscr','Rdst'],

    # need one
    # first only
    'mov':['0'],    #'Rscr','Rdst'],
    'shl':['0'],    #'Rscr','imm'],
    'shr':['0'],    #'Rscr','imm'],
    'not': ['0'],   #,'Rdst'],
    'inc':['0'],     #,'Rdst'],
    'dec':['0'],     #,'Rdst'],
    'out': ['0'],    #,'Rdst'], 
    'push':['0'],    #,'Rdst'],
    'jz':['0'],      #,'Rdst'],
    'jn':['0'],      #,'Rdst'],
    'jc':['0'],      #,'Rdst'],
    'jmp':['0'],      #,'Rdst'],
    'call':['0'],     #,'Rdst'],
}