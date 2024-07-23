`default_nettype none
`timescale 1ns/1ns

module weight_memory (
  input wire fetch_w,
  input wire [7:0] ui_in, 
  // TODO: Implement logic to load data into "memory" using these two inputs above. 
  // im getting yosys compilation errors BECAUSE i need to drive values INTO my memory!!!1

  input wire clk,
  input wire reset,
  input wire load_weight, 
  input wire [12:0] addr,
  output reg [7:0] weight1,
  output reg [7:0] weight2,
  output reg [7:0] weight3,
  output reg [7:0] weight4
);
  reg [7:0] memory [0:15]; // Simple memory to store weights
  integer i;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      for (i = 0; i < 16; i++) begin
        memory[i] <= 8'b0;
      end
      weight1 <= 8'b0;
      weight2 <= 8'b0;
      weight3 <= 8'b0;
      weight4 <= 8'b0;
    end else if (load_weight) begin
      weight1 <= memory[addr];
      weight2 <= memory[addr + 1];
      weight3 <= memory[addr + 2];
      weight4 <= memory[addr + 3];
    end
  end
endmodule
