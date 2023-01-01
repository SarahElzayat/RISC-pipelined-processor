from isa import *
import re

class Assembler:
    curr_location = 0
    commands = []
    arguments = {}
    lines=[]
    input_PATH = ''
    output_PATH = ''
    machine = {}

    def read_file(self,input_PATH):
        source = open(input_PATH,"r")
        lines=source.readlines()
        source.close()
        self.lines = lines
    
    def write_file(self,output_PATH):
        header = '// memory data file (do not edit the following line - required for mem load use)\n// instance=/processor/decode_stage_dut/reg_file_dut/reg_file\n// format=mti addressradix=d dataradix=s version=1.0 wordsperline=1'
        with open(output_PATH, 'w') as f:
            f.write(header+'\n')
            for i in range(0,524287):
                if i in self.machine.keys():
                    f.write('%d: %s\n' % (i, self.machine[i]))
                else:
                    f.write('%d: %s\n' % (i, 16*'x'))

    def sanitize (self):
        instructions = []
        arguments = {}
        i = 0
        print(self.lines)
        for line in self.lines:
            line = line.lower()
            if r'#' in line:
                line = line[0:line.find(r'#')]
            if ':' in line:
                line = line[line.find(':')+1:]
            line = line.strip()
            if line != '':
                print(line)
                line = re.split(r'[^a-z0-7.]+',line)
                command = line[0]
                args = line[1:]
                instructions.append(command)
                arguments.update({i:args})
                i += 1
        self.commands=instructions
        self.arguments = arguments

    def machine_code (self,command,arguments):
        sudo_line = instruction_table[command].copy()
        if len(arguments)==2 and sudo_line[2]!='imm':
            i = 0
            while i in range(2):
                sudo_line[i+1] = reg_table[arguments[1-i]]
                i += 1
            # extend to 16 bit 
            self.machine.update({self.curr_location:''.join(sudo_line)+5*'0'})
            self.curr_location = self.curr_location + 1

        # one argument instructions
        elif len(arguments) == 1 and command != '.org':
            sudo_line[1] = reg_table[arguments[0]]
            # extend to be 16bits
            self.machine.update({self.curr_location:''.join(sudo_line)+'0'*8}) 
            self.curr_location = self.curr_location + 1
    
        # zero argument instructions
        elif len(arguments) == 0:
            # extend to be 16bits
            self.machine.update({self.curr_location:sudo_line[0]+'0'*11})
            self.curr_location = self.curr_location + 1
    
        # shr,shl command
        elif len(arguments)==2 and command !='ldm':
            sudo_line[1] = reg_table[arguments[0]]
            # extend to be 16bits
            sudo_line[2]=bin(int(arguments[1], 16))[2:].zfill(8)
            self.machine.update({self.curr_location:''.join(sudo_line)})
            self.curr_location = self.curr_location + 1
        
        # ldm command
        elif len(arguments)==2 and command =='ldm':
            sudo_line[1] = reg_table[arguments[0]]
            # extend to be 32 bits
            sudo_line[2]=bin(int(arguments[1], 16))[2:].zfill(25)
            ldm = ''.join(sudo_line)
            self.machine.update({self.curr_location:ldm[:16]})
            self.curr_location = self.curr_location + 1
            self.machine.update({self.curr_location:ldm[17:]})
            self.curr_location = self.curr_location + 1
        
        # org command
        else:
            self.curr_location = int(arguments[0],16)

    def parse(self):
        for i in range (len(self.commands)):
            if self.commands[i] in instruction_table.keys():
                if len(self.arguments[i]) == len(instruction_table[self.commands[i]])-1:
                    self.machine_code(self.commands[i],self.arguments[i])
                else:
                    print('mismatch arguments in command  %s' % self.commands[i])
            else:
                print('unknown instruction  %s' % self.commands[i])


asm = Assembler()
asm.read_file('./test.txt')
asm.sanitize()
asm.parse()
asm.write_file('./output.mem')