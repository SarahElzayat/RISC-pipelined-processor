from isa import *
import re

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
            line = re.split(r'\s+|,+',line)
            command = line[0]
            args = line[1:]
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
            print('unknown instruction number %s' % commands[i])
    return machine


def machine_code (command,arguments):
    sudo_line = instruction_table[command].copy()
    if len(arguments)==2 and sudo_line[2]!='imm':
        i = 0
        while i in range(2):
            sudo_line[i+1] = reg_table[arguments[1-i]]
            i += 1
        # extend to 16 bit
        return ''.join(sudo_line)+5*'0'

    # one argument instructions
    elif len(arguments) == 1:
        sudo_line[1] = reg_table[arguments[0]]
        # extend to be 16bits
        return ''.join(sudo_line)+'0'*8

    # zero argument instructions
    elif len(arguments) == 0:
        # extend to be 16bits
        return sudo_line[0]+'0'*11

    # ldm,shr,shl command
    else:
        sudo_line[1] = reg_table[arguments[0]]
        # extend to be 16bits
        sudo_line[2]=(8-len(arguments[1]))*'0'+arguments[1]
        return ''.join(sudo_line) 

def bin2hex(bit_string):
    bit_string = '0b'+bit_string
    hex_string = str(hex(int(bit_string, 2)))[2:]
    hex_string = hex_string.zfill(2)
    hex_string=(4-len(hex_string))*'0'+hex_string
    return hex_string

def assembler(input_path,output_path,hex_flag):
    lines = read_file(input_path)
    commands,arguments = sanitize(lines)
    output = parse(commands,arguments)
    if hex_flag:
        for i in range (len(output)):
            output[i] = bin2hex(output[i])+'\n'
    write_file(output_path,output)

input_path = './assembler/test.txt'
output_path = './assembler/output.txt'

assembler(input_path,output_path,hex_flag=1)