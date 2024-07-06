`timescale 1ns / 1ns

/*  TODO: Figure out how to facilitate stream of data from computer to TPU 
^^ how can i move data from some memory partition from outside of my TPU, into my TPU. 
... Because at the moment I'm harcoding the weights and inputs.
*/

module tb;
  // Inputs
  reg clk;
  reg reset;
  // Outputs

  // Instantiate the top level module
  main uut (
    // Inputs
    .clk(clk),
    .reset(reset)
    // Outputs
  );

  // Clock generation
  always #5 clk = ~clk;

endmodule
