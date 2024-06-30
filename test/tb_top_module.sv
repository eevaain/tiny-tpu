`timescale 1ns / 1ns

/*  TODO: Figure out how to facilitate stream of data from computer to TPU 
^^ how can i move data from some memory partition from outside of my TPU, into my TPU. 
... Because at the moment I'm harcoding the weights and inputs.
*/

// TODO: Since tiny tapeout has 8 input and 8 ouput pins, perhaps create a mechanism to load in data, 8 bits at a time here...

module tb_top_level_module;
  // Inputs
  reg clk;
  reg reset;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;

  // Outputs
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Instantiate the top level module
  tt_um_tpu uut (

`ifdef GL_TEST
    .VPWR(1'b1),
    .VGND(1'b0),
`endif

    // Inputs
    .clk(clk),
    .rst_n(reset),
    .ena(ena),
    .ui_in(ui_in),
    .uio_in(uio_in),
    // Outputs
    .uo_out(uo_out),
    .uio_out(uio_out),
    .uio_oe(uio_oe)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Simulation starts HERE
  initial begin
    // Initialize inputs
    clk = 0;
    reset = 0;
    ena = 0;
    ui_in = 0;
    uio_in = 0;

    // Apply reset
    #10;
    reset = 1;
    ena = 1;
    #10;
    reset = 0;

    // Apply test stimulus here
    // ...
  end
endmodule
