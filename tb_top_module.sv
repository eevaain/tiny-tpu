`timescale 1ns / 1ns

module tb_top_level_module;
  // Inputs
  reg clk;
  reg reset;
  reg [15:0] instruction;
  // Outputs
  wire [31:0] unified_mem [0:63];

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
    // Initialize inputs (registers outside the module)
    clk = 0;
    reset = 0;
    instruction = 0;

    // Apply reset (these are also registers outside the module)
    reset = 1;
    #10;
    reset = 0;
    #10;

    /// Load base address for weights
    instruction = 16'b001_0000000001111;  // LOAD_ADDR 0x000F (16th address)
    #10;

    /// Load weights into systolic array
    instruction = 16'b010_0000000000000;  // LOAD_WEIGHT (Weights are transferred from weight memory into mmu)
    #10;

    /// Load base address for activation inputs
    instruction = 16'b001_0000000011110;  // LOAD_ADDR 0x001E (30th address)
    #10;

    /// Activation inputs are transferred from unified buffer to input setup unit
    instruction = 16'b011_0000000000000;  // LOAD_INPUT 
    #10;

    /// Convolutions begin within array. 
    instruction = 16'b100_0000000000000;  // COMPUTE/VALID (Compute starts, systolic operations are automated by here)

    #10; // now how can i get rid of this extra clock cycle?

    #10; // loads in a_in1 = 11; a_in2 = 0;
    #10; // loads in a_in1 = 12; a_in2 = 21;
    #10; // loads in a_in1 = 0; a_in2 = 22;

    #10; // mandatory empty input to allow partial sums to go into accumulator (i'm sure this one is mandatory)
    #10; // mandatory empty input to allow partial sums to go into accumulator (wait too sure about this one...)

    /* 

    // TODO: LOAD_ADDR instruction here
    instruction = 16'b001_0000000001111;  // LOAD_ADDR 0x001E (16th address)
    #10;

    // TODO: need an instruction here to transfer accumulator product matrix rows into the unified buffer 

    instruction = 16'b001_0000000001111;  // LOAD_ADDR 0x001E (16th address)
    #10;

    */

    // Monitor unified buffer
    $display("Unified Buffer at time %t:", $time);
    for (integer i = 0; i < 64; i = i + 1) begin
      $display("unified_mem[%0d] = %0d", i, unified_mem[i]);
    end

    // Finish the simulation
    $finish;
  end

endmodule
