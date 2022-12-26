from isa import *

def sanitize (lines):
    instructions = []
    arguments = {}
    i = 0
    for line in lines:
        if r'//' in line:
            line = line[0:line.find(r'//')]
        if ':' in line:
            line = line[line.find(':')+1:]
        line = line.strip()
        if line != '':
            print(line)
            command = line[0:line.find(' ')].strip()
            args = line[line.find(' ') + 1:].replace(' ', '').split(',')
            instructions.append(command)
            arguments.update({i:args})
            i += 1
    return instructions,arguments

def read_file(PATH):
    source = open(PATH,"r")
    lines=source.readlines()
    source.close()
    return lines

def write_file(PATH,output):
    dest = open(PATH,"w")
    dest.writelines(output)
    dest.close()

def parse(commands,arguments):
    machine = []
    for i in range (len(commands)):
        if commands[i] in instruction_table.keys():
            if len(arguments[i]) == len(instruction_table[commands[i]])-1:
                machine.append(machine_code(commands[i],arguments[i])+'\n')
            else:
                print('mismatch arguments in command number %d' % i)
        else:
            print('unknown instruction number %d' % i)
    return machine


def machine_code (command,arguments):
    sudo_line = instruction_table[command]
    # 2 argument instructions except ldm
    if len(arguments)==2 and command!='ldm':
        i = 0
        while i in range(2):
            sudo_line[i+1] = reg_table[arguments[i]]
            i += 1
        # extend to 16 bit
        return ''.join(sudo_line)+5*'0'

    # one argument instructions
    elif len(arguments) == 1:
        sudo_line[0] = reg_table[arguments[0]]
        # extend to be 16bits
        return ''.join(sudo_line)+'0'*8

    # zero argument instructions
    elif len(arguments) == 0:
        # extend to be 16bits
        return sudo_line[0]+'0'*11

    # ldm command
    else:
        sudo_line[0] = reg_table[arguments[0]]
        # extend to be 16bits
        8-len(arguments[1])*'0'+arguments[1]
        return ''.join(sudo_line) 
    
lines = read_file('./assembler/test.txt')
commands,arguments = sanitize(lines)
output = parse(commands,arguments)
write_file('./assembler/output.txt',output)