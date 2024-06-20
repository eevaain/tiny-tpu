`timescale 1ns / 1ns

/*  TODO: Figure out how to facilitate stream of data from computer to TPU 
^^ how can i move data from some memory partition from outside of my TPU, into my TPU. 
... Because at the moment I'm harcoding the weights and inputs.
*/

module tb_top_level_module;
  // Inputs
  reg clk;
  reg reset;
  // Outputs
  wire [31:0] unified_mem [0:63];

  // Instantiate the top level module
  main uut (
    // Inputs
    .clk(clk),
    .reset(reset),
    // Outputs
    .unified_mem(unified_mem)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Simulation starts HERE
  initial begin
    // Initialize inputs. 
    clk = 0;
    reset = 0;
    reset = 1;
    // "Let go" of reset (chip starts running)
    #10;
    reset = 0;
  end
endmodule
