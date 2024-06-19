`timescale 1ns / 1ns

/*  TODO: Figure out how to facilitate stream of data from computer to TPU 
^^ how can i move data from some memory partition from outside of my TPU, into my TPU. 
... Because at the moment I'm harcoding the weights and inputs.
*/

module tb_top_level_module;
  // Inputs
  reg clk;
  reg reset;
  reg [15:0] instruction;
  // Outputs
  wire [31:0] unified_mem [0:63];

  // Instruction Memory
  reg [15:0] instruction_mem [0:7]; // Adjust the size as needed
  integer instruction_pointer;
  integer compute_cycle_counter; // Counter for compute cycles

  // Instantiate the top level module
  main uut (
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .unified_mem(unified_mem)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Initial block to initialize inputs and apply test vectors
  initial begin
    // Initialize inputs
    clk = 0;
    reset = 0;
    instruction = 0;

    // Initialize instruction memory
    instruction_mem[0] = 16'b001_0000000001111;  // LOAD_ADDR 0x000F (16th address)
    instruction_mem[1] = 16'b010_0000000000000;  // LOAD_WEIGHT (Weights are transferred from weight memory into mmu)
    instruction_mem[2] = 16'b001_0000000011110;  // LOAD_ADDR 0x001E (30th address)
    instruction_mem[3] = 16'b011_0000000000000;  // LOAD_INPUT 
    instruction_mem[4] = 16'b100_0000000000000;  // COMPUTE (Compute starts, systolic operations are automated by here)
    instruction_mem[5] = 16'b001_0000000000111;  // LOAD_ADDR 0x0007 (7th address)
    instruction_mem[6] = 16'b101_0000000000000;  // STORE
    instruction_mem[7] = 16'b000_0000000000000;  // NOP or END (indicate end of instructions)

    instruction_pointer = 0;
    compute_cycle_counter = 0; // Initialize compute cycle counter

    // Apply reset
    reset = 1;
    #10;
    reset = 0;

    // Wait until 145 ns and print the contents of the unified buffer
    #165; // 10ns for reset and 135ns to reach 145ns (product matrix is printed at time 165)
    // hmmmm adding this FSM does increase the amount of clock cycles then previously... but only for initialization with the loading instructions lol
    $display("Unified Buffer at time %t:", $time);
    for (integer i = 0; i < 64; i = i + 1) begin
      $display("unified_mem[%0d] = %0d", i, unified_mem[i]);
    end
  end

  // FSM states
  typedef enum reg [1:0] {IDLE, FETCH, EXECUTE, FINISH} state_t;
  state_t state = IDLE;

  // TODO: Move this state machine into the control unit
  // Sequential logic to update the state
  // This is the "state transition block" (sets the state)
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
    end
  end

  // Combinational logic to perform actions based on the state
  // "This is the combinational block"
  // ^^ it assigns an action to each state
  always @(*) begin
    case (state) // updates based on change in state
      IDLE: instruction = 16'b000_0000000000000;
      FETCH: instruction = instruction_mem[instruction_pointer];
      EXECUTE: begin
        if (instruction_mem[instruction_pointer] == 16'b100_0000000000000 && compute_cycle_counter < 5) begin
          instruction = 16'b100_0000000000000; // maintain COMPUTE instruction
        end else begin
          instruction_pointer = instruction_pointer + 1;
          instruction = instruction_mem[instruction_pointer];
        end
      end
      FINISH: instruction = 16'b000_0000000000000;
    endcase
  end

  // Monitor unified buffer after execution
  always @(posedge clk) begin
    if (state == FINISH) begin
      $display("Unified Buffer at time %t:", $time);
      for (integer i = 0; i < 64; i = i + 1) begin
        $display("unified_mem[%0d] = %0d", i, unified_mem[i]);
      end
      $finish;
    end
  end

endmodule
