module weight_memory (
  input [12:0] addr,
  output reg [15:0] weight1,
  output reg [15:0] weight2,
  output reg [15:0] weight3,
  output reg [15:0] weight4
);

  reg [15:0] memory [0:255]; // Simple memory to store weights

  initial begin
    // Initialize memory with weights
    memory[16'h000F] <= 3;
    memory[16'h0010] <= 5;
    memory[16'h0011] <= 4;
    memory[16'h0012] <= 6;
  end

  always @(*) begin
    weight1 <= memory[addr];
    weight2 <= memory[addr + 1];
    weight3 <= memory[addr + 2];
    weight4 <= memory[addr + 3];
  end
endmodule
