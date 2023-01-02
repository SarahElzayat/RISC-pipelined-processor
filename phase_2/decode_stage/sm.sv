module sm (
    input clk,reset,
    input interrupt_signal,
    input [15:0] instruction,
    input [32-1:0] PC,
    output logic  reg_write, mem_read, mem_write, mem_pop,mem_push,
    output logic   clear_instruction ,flag_reg_select,pc_choose_memory,
    output logic [2 :0] jump_selector,
    output logic [3 :0] r_scr,r_dst,
    output logic  [1:0] mem_src_select,
    output logic  [3:0] ALUOp,
    output logic  [1:0] wb_sel,
    output logic stall_fetch_from_cu,
    output logic  [1:0] mem_addsel,
    output logic  [1:0] carry_sel,
    output logic  alu_srcsel,
    output logic  outport_enable,
    output logic  inport_sel,
    output logic  flagreg_enable,
    output logic pc_write_cu,
    output logic pc_choose_interrupt,
    output logic pc_choose_PC,
    output logic  pc_plus_1_or_pc_minus_1
  );

  typedef enum int unsigned { IDLE,JUMP_1, PIPE_WAIT , PUSH_FLAGS , PUSH_PC1 ,PUSH_PC2, POP_PC1,POP_PC2,POP_FLAGS} State;

  State current_state;
  State previos_state;

  logic [4:0] counter;
  wire [4:0] opcode;

  assign opcode = instruction[15:11];

  // output logic
  always_comb
  begin
    //----------------default values-------------------
    //fetch stage signals
    inport_sel = 1'b0;
    clear_instruction = 1'b0;
    // execution stage signals
    ALUOp = 4'b1111;
    alu_srcsel = 1'b0;
    stall_fetch_from_cu = 1'b0;
    jump_selector = 3'b000;
    carry_sel = 2'b00;
    flag_reg_select = 1'b0;
    pc_choose_memory = 1'b0;
    flagreg_enable = 1'b0;
    // memory stage signals
    mem_read = 1'b0;
    mem_write = 1'b0;
    mem_pop = 1'b0;
    mem_push = 1'b0;
    mem_addsel = 2'b00;
    mem_src_select = 2'b00;
    // write back stage signals
    reg_write = 1'b0;
    wb_sel = 2'b01;
    outport_enable = 1'b0;
    pc_choose_interrupt = 1'b0;
    pc_choose_PC = 1'b0;
    //registers identifiers
    r_dst = 4'bzzzz;
    r_scr = 4'bzzzz;
    pc_write_cu <= 1'b1;
    pc_plus_1_or_pc_minus_1 <= 1'b1;

    case (current_state)
      IDLE,PIPE_WAIT :

      begin
        //NOTE - NORMAL EXECUTION
        if(current_state == PIPE_WAIT)
        begin
          // pc_write_cu <= 1'b0;
          clear_instruction <= 1'b1;
          //   pc_choose_interrupt <= 1'b1;
          pc_choose_PC <= 1'b1; // choose same PC unless there is a jump

        end
        if(current_state == PIPE_WAIT && counter > 0)
        begin
          begin

            // stall_fetch_from_cu <= 1'b1;
            // dont change the pc till pushing
            if(counter == 4)
            begin
              pc_choose_interrupt <= 1'b1;

              // pc_write_cu <= 1'b1;
            end
          end
        end
        else
        begin
          case (instruction[15:14])
            // R-type instructions (00)
            2'b00:
            begin
              // execution stage signals
              flagreg_enable = 1'b1;
              // write back stage signals
              reg_write = 1'b1;
              case(opcode[2:0])
                // NOT Rdst => 000
                3'b000:
                begin
                  // execution stage signals
                  ALUOp = 4'b0000;
                  //registers identifiers
                  // r_scr = instruction[10:8];
                  r_dst = {1'b0,instruction[10:8]};
                end

                // INC Rdst
                3'b001:
                begin
                  // execution stage signals
                  ALUOp = 4'b0001;
                  //registers identifiers
                  // r_scr = instruction[10:8];
                  r_dst = {1'b0,instruction[10:8]};
                end

                // DEC Rdst
                3'b010:
                begin
                  // execution stage signals
                  ALUOp = 4'b0010;
                  //registers identifiers
                  // r_scr = instruction[10:8];
                  r_dst = {1'b0,instruction[10:8]};
                end
                // ADD Rds,Rscr
                3'b011:
                begin
                  // execution stage signals
                  ALUOp = 4'b0011;
                  //registers identifiers
                  r_scr = {1'b0,instruction[7:5]};
                  r_dst = {1'b0,instruction[10:8]};
                end

                // SUB Rdst,Rscr
                3'b100:
                begin
                  // execution stage signals
                  ALUOp = 4'b0100;
                  //registers identifiers
                  r_scr = {1'b0,instruction[7:5]};
                  r_dst = {1'b0,instruction[10:8]};
                end

                // AND Rdst,Rscr
                3'b101:
                begin
                  // execution stage signals
                  ALUOp = 4'b0101;
                  //registers identifiers
                  r_scr = {1'b0,instruction[7:5]};
                  r_dst = {1'b0,instruction[10:8]};
                end

                // OR Rdst,Rscr
                3'b110:
                begin
                  // execution stage signals
                  ALUOp = 4'b0110;
                  //registers identifiers
                  r_scr = {1'b0,instruction[7:5]};
                  r_dst = {1'b0,instruction[10:8]};
                end
                default:
                  ;
              endcase
            end

            //I-type instructions with one operand (01)
            2'b01:
            begin
              case(opcode[2:0])
                // NOP
                3'b000:
                  ;

                // SETC
                3'b001:
                begin
                  // execution stage signals
                  carry_sel = 2'b01;
                  flagreg_enable = 1'b1;
                end
                // CLRC
                3'b010:
                begin
                  // execution stage signals
                  carry_sel = 2'b10;
                  flagreg_enable = 1'b1;
                end
                // OUT Rdst
                3'b011:
                begin
                  // write back stage signals
                  outport_enable = 1'b1;
                  //registers identifiers
                  r_scr = {1'b0,instruction[10:8]};
                end
                // IN Rdst
                3'b100:
                begin
                  //fetch stage signals
                  inport_sel = 1'b1;
                  // write back stage signals
                  reg_write = 1'b1;
                  //NOTE - @Atta ADDED THIS
                  wb_sel = 2'b11;
                  //reg identifiers
                  r_dst = {1'b0,instruction[10:8]};
                end
                // PUSH Rdst
                3'b101:
                begin
                  // memory stage signals
                  mem_push = 1'b1;
                  mem_write = 1'b1;
                  mem_addsel = 2'b10;
                  mem_src_select = 2'b11;
                  //reg identifiers
                  r_dst = {1'b0,instruction[10:8]};
                end
                // POP Rdst
                3'b110:
                begin
                  // memory stage signals
                  mem_read = 1'b1;
                  mem_pop = 1'b1;
                  mem_addsel = 2'b10;
                  mem_src_select = 2'b11;
                  // write back stage signals
                  reg_write = 1'b1;
                  wb_sel = 2'b10;
                  //reg identifiers
                  // r_scr = instruction[10:8];
                  r_dst = {1'b0,instruction[10:8]};
                end
                default:
                  ;
              endcase
            end
            //I-type instructions with two operands (10)
            2'b10:
            begin
              case(opcode[2:0])
                // MOV Rdst,Rscr
                3'b000:
                begin
                  // write back stage signals
                  reg_write = 1'b1;
                  wb_sel = 2'b01;
                  //registers identifiers
                  r_scr = {1'b0,instruction[7:5]};
                  r_dst = {1'b0,instruction[10:8]};
                end
                // LDM Rdst,imm
                3'b001:
                begin
                  //fetch stage signals
                  clear_instruction = 1'b1;
                  // write back stage signals
                  reg_write = 1'b1;
                  wb_sel = 2'b00;
                  //reg identifiers
                  r_dst = {1'b0,instruction[10:8]};
                end
                // LDD Rdst,Rscr
                3'b010:
                begin
                  // memory stage signals
                  mem_read = 1'b1;
                  mem_addsel = 2'b01;
                  // write back stage signals
                  reg_write = 1'b1;
                  wb_sel = 2'b10;
                  //registers identifiers
                  r_scr = {1'b0,instruction[7:5]};
                  r_dst = {1'b0,instruction[10:8]};
                end
                // STD Rdst,Rscr
                3'b011:
                begin
                  // memory stage signals
                  mem_write = 1'b1;
                  mem_src_select = 2'b11;
                  mem_addsel = 2'b00;
                  //registers identifiers
                  r_scr = {1'b0,instruction[7:5]};
                  r_dst = {1'b0,instruction[10:8]};
                end
                // SHL Rdst,imm
                3'b100:
                begin
                  // execution stage signals
                  ALUOp = 4'b0111;
                  alu_srcsel = 1'b1;
                  flagreg_enable = 1'b1;
                  // write back stage signals
                  reg_write = 1'b1;
                  wb_sel = 2'b01;
                  //registers identifiers
                  // r_scr = instruction[10:8];
                  r_dst = {1'b0,instruction[10:8]};
                end
                // SHR Rdst,imm
                3'b101:
                begin
                  // execution stage signals
                  ALUOp = 4'b1000;
                  alu_srcsel = 1'b1;
                  flagreg_enable = 1'b1;
                  // write back stage signals
                  reg_write = 1'b1;
                  wb_sel = 2'b01;
                  //registers identifiers
                  // r_scr = instruction[10:8];
                  r_dst = {1'b0,instruction[10:8]};
                end
                default :
                  ;
              endcase
            end

            2'b11:
            begin
              // branches
              case (instruction[13:11])
                3'b000 , 3'b001 , 3'b010 ,3'b011: // JMP zero , negative , carry , no-condition
                begin
                  jump_selector <= {1'b1,instruction[12:11]};
                  //registers identifiers
                  r_dst = {1'b0,instruction[10:8]};
                end
                3'b100: // call
                begin
                  // push pc1 and pc2
                  // TODO: stop the fetch
                  // jmp-no-condition in execute stage
                  // jump_selector <= 3'b111;
                  //registers identifiers
                  r_dst = {1'b0,instruction[10:8]};

                  // TODO: stop the fetch
                  // push pc1
                  // push pc_1 --> upper part first
                  mem_src_select <= 2'b01;
                  mem_push <= 1'b1;
                  stall_fetch_from_cu <= 1'b1;
                  mem_write <= 1'b1;
                  mem_addsel <= 2'b10;
                end
                3'b101: // ret
                begin
                  // pop pc and continue
                  mem_pop <= 1'b1; // first part
                  mem_read <= 1'b1;
                  mem_addsel <= 2'b10;
                  clear_instruction <= 1'b1;
                  // pc1
                  r_dst <= 4'b1000;
                end
                3'b110: // reti
                begin
                end
                default :
                  ;
              endcase

            end
            default:
            begin
            end
          endcase
        end
      end
      JUMP_1:
      begin

        // TODO: stop the fetch
        // push pc2
        mem_src_select <= 2'b10;
        mem_push <= 1'b1;
        // r_dst = instruction[10:8];
        mem_write = 1'b1;
        mem_addsel = 2'b10;
        jump_selector <= 3'b111;
        // if (previos_state == PIPE_WAIT)
        //   pc_choose_PC <= 1'b1;
      end



      PUSH_PC1:
      begin
        // push pc1
        // push pc_1 --> upper part first
        // pc_write_cu <= 1'b0;
        mem_src_select <= 2'b01;
        mem_push <= 1'b1;
        stall_fetch_from_cu <= 1'b1;
        mem_write <= 1'b1;
        pc_choose_PC <= 1'b1;
        pc_plus_1_or_pc_minus_1 <= 1'b0;

      end
      PUSH_PC2:
      begin
        // pc_write_cu <= 1'b0;
        // push pc1
        // push pc_1 --> upper part first
        mem_src_select <= 2'b10;
        mem_push <= 1'b1;
        // stall_fetch_from_cu <= 1'b1;
        mem_write <= 1'b1;
        pc_choose_PC <= 1'b1;
        pc_plus_1_or_pc_minus_1 <= 1'b0;

      end
      PUSH_FLAGS :
      begin
        // pc_choose_PC <= 1'b1;

        mem_src_select <= 2'b00;
        mem_push <= 1'b1;
        // stall_fetch_from_cu <= 1'b1;
        mem_write <= 1'b1;
        // pc_choose_interrupt <= 1'b1;

      end
      POP_FLAGS:
      begin
        flag_reg_select <= 1'b1;
        // pop pc and continue
        mem_pop <= 1'b1; // first part
        mem_read = 1'b1;
        mem_addsel = 2'b10;
        r_dst <= 4'b1010;
      end
      POP_PC1:
      begin
        mem_pop <= 1'b1; // first part
        mem_read = 1'b1;
        mem_addsel = 2'b10;
        r_dst <= 4'b1000;
      end
      POP_PC2:
      begin
        // leach pop at the first cycle
        clear_instruction <= 1'b1;
        if(counter == 0)
        begin
          mem_pop <= 1'b1;
          // pop pc and continue
          mem_read = 1'b1;
          mem_addsel = 2'b10;
          // It will take pass the first cycle (EXECUTE) and gget the PC in the second cycle (MEMORY)
          // Change the PC HERE
          pc_choose_memory <= 1'b1;
          r_dst <= 4'b1001;
        end
        if(counter  == 2)
        begin
          clear_instruction <= 1'b0;
        end

      end

      default :
      begin
      end
    endcase

  end


  // state ff and transition
  always_ff@(posedge clk or negedge reset)
  begin
    previos_state <= current_state;
    if(reset)
    begin
      current_state <= IDLE;
    end
    else
    begin
      counter <= 0;
      begin
        case (current_state)
          IDLE, PIPE_WAIT:
            if(interrupt_signal == 1)
            begin
              current_state <= PIPE_WAIT;
            end
            else
            begin
              if(current_state == PIPE_WAIT)
              begin
                counter <= counter +1;
                // wait 5 cycles
                if(counter  == 4)
                begin
                  current_state <= PUSH_PC1;
                  counter <= 0;
                end
              end
              case (instruction[15:14])
                //NOTE - NORMAL EXECUTION
                2'b00:
                begin
                end
                2'b01:
                begin
                end
                2'b10:
                begin
                end
                2'b11:
                begin
                  // branches
                  case (instruction[13:11])
                    3'b000 , 3'b001 , 3'b010 ,3'b011: // JMP zero , negative , carry , no-condition
                    begin
                    end
                    3'b100: // call
                    begin
                      // push pc1 and pc2
                      current_state <= JUMP_1;

                    end
                    3'b101: // ret
                    begin
                      // pop pc and continue
                      counter <= 0;
                      current_state <= POP_PC2;
                    end
                    3'b110: // reti
                    begin
                      current_state <= POP_FLAGS;
                    end
                    default :
                      ;
                  endcase

                end
                default:
                begin
                  current_state <= IDLE;
                end
              endcase

            end
          //-----------------------------------------------------CALL
          JUMP_1:
          begin
            current_state <= previos_state;
            // if(previos_state == PIPE_WAIT)
            //   counter <= counter +1;
          end

          //-----------------------------------------------------INTERRUPT
          PUSH_PC1:
          begin
            current_state <= PUSH_PC2;
          end
          PUSH_PC2:
          begin
            current_state <= PUSH_FLAGS;
          end
          PUSH_FLAGS :
          begin
            current_state <= IDLE;
          end

          //-----------------------------------------------------RET
          POP_FLAGS:
          begin
            current_state <= POP_PC1;

          end
          POP_PC1:
          begin
            current_state = POP_PC2;
          end
          POP_PC2:
          begin
            if(previos_state == PIPE_WAIT)
              previos_state <= PIPE_WAIT;
            else
              previos_state <= IDLE;

            counter <= counter +1;
            // it waits till the value in mem is present
            if(counter  == 2)
            begin
              current_state <= previos_state;

              counter <= 0;
            end
          end

          default :
            current_state <= IDLE;

        endcase
      end
    end
  end

endmodule
