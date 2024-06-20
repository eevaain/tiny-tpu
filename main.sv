module main (
  input clk,
  input reset,
  output [31:0] unified_mem [0:63]  // Output for unified buffer memory
);
  reg [15:0] instruction; // Instruction register
  reg [15:0] instruction_mem [0:7]; // Instruction memory. Adjust the size as needed.   
                                    // TODO: Turn instruction_mem into its own memory partition? 

  integer instruction_pointer;
  integer compute_cycle_counter; // Counter for compute cycles

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

  // FSM states
  typedef enum reg [1:0] {IDLE, FETCH, EXECUTE, FINISH} state_t;
  state_t state = IDLE;

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

  // TODO: Move this state machine into the control unit
  always @(posedge clk) begin
    if (state == FINISH) begin
      $display("Unified Buffer at time %t:", $time);
      for (integer i = 0; i < 64; i = i + 1) begin
        $display("unified_mem[%0d] = %0d", i, unified_mem[i]);
      end
      $finish;
    end
  end

  wire [15:0] a_in1;
  wire [15:0] a_in2;

  // Internal signals for control unit
  wire [12:0] base_address;
  wire load_weight;
  wire load_input;
  wire valid;
  wire store; 

  // Internal signals for accumulated values from the systolic array
  wire [31:0] systolic_acc_out1;
  wire [31:0] systolic_acc_out2;
  
  wire acc1_full;
  wire acc2_full;

  // Internal signals for weights from memory
  wire [15:0] weight1;
  wire [15:0] weight2;
  wire [15:0] weight3;
  wire [15:0] weight4;

  // Internal signals for output matrix individual row vectors to unified buffer
  wire [31:0] acc1_mem_0_to_ub;
  wire [31:0] acc1_mem_1_to_ub;
  wire [31:0] acc2_mem_0_to_ub;
  wire [31:0] acc2_mem_1_to_ub;

  // Internal signals for activation inputs from unified buffer
  wire [31:0] out_ub_to_input_setup_00;
  wire [31:0] out_ub_to_input_setup_01;
  wire [31:0] out_ub_to_input_setup_10;
  wire [31:0] out_ub_to_input_setup_11;

  // Instantiate the control unit
  control_unit cu (
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .load_weight(load_weight),
    .base_address(base_address),
    .load_input(load_input),
    .valid(valid),
    .store(store)
  );

  // Instantiate the weight memory
  weight_memory wm (
    .addr(base_address),
    .weight1(weight1),
    .weight2(weight2),
    .weight3(weight3),
    .weight4(weight4)
  );

  input_setup is (
    .clk(clk),
    .reset(reset),
    .valid(valid),

    .a11(out_ub_to_input_setup_00),
    .a12(out_ub_to_input_setup_01),
    .a21(out_ub_to_input_setup_10),
    .a22(out_ub_to_input_setup_11),

    .a_in1(a_in1),
    .a_in2(a_in2)
  );

  // Instantiate the systolic array
  mmu systolic_array_inst (
    .clk(clk),
    .reset(reset),
    .load_weight(load_weight),
    .valid(valid),
    .a_in1(a_in1),
    .a_in2(a_in2),
    .weight1(weight1),
    .weight2(weight2),
    .weight3(weight3),
    .weight4(weight4),
    .acc_out1(systolic_acc_out1),
    .acc_out2(systolic_acc_out2)
  );

  // Instantiate the first accumulator
  accumulator acc1 (
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .acc_in(systolic_acc_out1),
    .acc_mem_0(acc1_mem_0_to_ub),
    .acc_mem_1(acc1_mem_1_to_ub),
    .full(acc1_full)
  );

  // Instantiate the second accumulator
  accumulator acc2 (
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .acc_in(systolic_acc_out2),
    .acc_mem_0(acc2_mem_0_to_ub),
    .acc_mem_1(acc2_mem_1_to_ub),
    .full(acc2_full)
  );

  // Instantiate the unified buffer
  unified_buffer ub (
    // inputs 
    .clk(clk),
    .reset(reset),
    .load_input(load_input),
    .store_acc1(acc1_full), // Only store when accumulator is full
    .store_acc2(acc2_full), // Only store when accumulator is full
    .acc1_mem_0(acc1_mem_0_to_ub),
    .acc1_mem_1(acc1_mem_1_to_ub),
    .acc2_mem_0(acc2_mem_0_to_ub),
    .acc2_mem_1(acc2_mem_1_to_ub),
    .addr(base_address),
    // outputs
    .unified_mem(unified_mem),
    .out_ub_00(out_ub_to_input_setup_00),
    .out_ub_01(out_ub_to_input_setup_01),
    .out_ub_10(out_ub_to_input_setup_10),
    .out_ub_11(out_ub_to_input_setup_11),
    // have a store or retrieve flag? (r/w)
    .store(store)
  );

  // Track and display a_in1 and a_in2 values per clock cycle
  // always @(posedge clk or posedge reset) begin
  //   if (reset) begin
  //     // Do nothing on reset
  //   end else begin
  //     $display("Time: %0t, a_in1: %0d, a_in2: %0d", $time, a_in1, a_in2);
  //   end
  // end

endmodule
