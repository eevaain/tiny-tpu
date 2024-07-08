module control_unit (
  input clk,
  input reset,
  // input wire [15:0] instruction,
  output reg load_weight,
  output reg [12:0] base_address,
  output reg load_input,
  output reg valid,
  output reg store
);

    // TESTBENCH CODE (These hard-coded values won't be taped out)
  initial begin
    instruction = 0;
    instruction_pointer = 0;
    compute_cycle_counter = 0; // Initialize compute cycle counter

    instruction_mem[0] = 16'b001_0000000001111;  // LOAD_ADDR 0x000F (16th address)
    instruction_mem[1] = 16'b010_0000000000000;  // LOAD_WEIGHT (Weights are transferred from weight memory into mmu)
    instruction_mem[2] = 16'b001_0000000011110;  // LOAD_ADDR 0x001E (30th address)
    instruction_mem[3] = 16'b011_0000000000000;  // LOAD_INPUT 
    instruction_mem[4] = 16'b100_0000000000000;  // COMPUTE (Compute starts, systolic operations are automated by here)
    instruction_mem[5] = 16'b001_0000000000111;  // LOAD_ADDR 0x0007 (7th address)
    instruction_mem[6] = 16'b101_0000000000000;  // STORE
    instruction_mem[7] = 16'b000_0000000000000;  // NOP or END (indicate end of instructions)
  end

  reg [15:0] instruction_mem [0:7]; // Instruction memory. Adjust the size as needed.   
                                    // TODO: Turn instruction_mem into its own memory partition? 
  reg [15:0] instruction; // Instruction register
  // FSM states
  typedef enum reg [1:0] {IDLE, FETCH, EXECUTE, FINISH} state_t;
  state_t state = IDLE;

  integer instruction_pointer;
  integer compute_cycle_counter; // Counter for compute cycles

  // TODO: Move this state machine into the control unit
  // Instruction state transition block 
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      instruction_pointer <= 0;
      compute_cycle_counter <= 0; // Reset compute cycle counter
    end else begin
      case (state)
        IDLE: state <= FETCH;
        FETCH: state <= EXECUTE;
        EXECUTE: begin
          if (instruction_mem[instruction_pointer] == 16'b100_0000000000000) begin
            if (compute_cycle_counter < 5) begin
              compute_cycle_counter <= compute_cycle_counter + 1;
              state <= EXECUTE; // Remain in EXECUTE state for 6 cycles
            end else begin
              compute_cycle_counter <= 0; // Reset counter
              state <= FETCH; // Move to next instruction after 6 cycles
            end
          end else begin
            if (instruction_mem[instruction_pointer] == 16'b000_0000000000000) 
              state <= FINISH;
            else 
              state <= FETCH;
          end
        end
        FINISH: state <= FINISH;
      endcase

      if (state == FINISH) begin
      end
    end
  end

  // TODO: Move this state machine into the control unit
  // Combinational block (assigns actions to each state)
  always @(*) begin
    case (state) // Updates based on change in state
      IDLE: instruction = 16'b000_0000000000000;
      FETCH: instruction = instruction_mem[instruction_pointer];
      EXECUTE: begin
        if (instruction_mem[instruction_pointer] == 16'b100_0000000000000 && compute_cycle_counter < 5) begin
          instruction = 16'b100_0000000000000; // Maintain COMPUTE instruction while on COMPUTE. "5" clock cycle delay on this instruction. 
        end else begin
          instruction_pointer = instruction_pointer + 1;
          instruction = instruction_mem[instruction_pointer];
        end
      end
      FINISH: instruction = 16'b000_0000000000000;
    endcase
  end

  // ISA Control
  always @(*) begin
    if (reset) begin
      base_address = 0;
      load_weight = 0;
      load_input = 0;
      valid = 0;
      store = 0; 
    end else begin
      // Default values for unused flags
      base_address = base_address;
      load_weight = 0;
      load_input = 0;
      valid = 0;
      store = 0; 

      case (instruction[15:13])
        3'b001: begin  // LOAD_ADDR
          base_address = instruction[12:0];
        end
        3'b010: begin  // LOAD_WEIGHT
          load_weight = 1;
        end
        3'b011: begin // LOAD_INPUTS
          load_input = 1; 
        end
        3'b100: begin // VALID (compute)
          valid = 1; 
        end
          3'b101: begin // STORE
          store = 1; 
        end
        default: begin
          // All flags are already zeroed by default
        end
      endcase
    end
  end

  // Program Counter Control

endmodule
