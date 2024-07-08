module weight_memory (
  input [12:0] addr,
  output reg [7:0] weight1,
  output reg [7:0] weight2,
  output reg [7:0] weight3,
  output reg [7:0] weight4
);

  reg [7:0] memory [0:31]; // Simple memory to store weights

  initial begin
    // Initialize memory with weights (ROW-WISE)
    // TODO: Weight matrix is currently implemented COL-WISE. The numbers are in the correct position, but we
    // ... need to input the weights ROW-WISE and then transpose them to be as such here. (as displayed in the hardcoded mem vals)
    // WEIGHT MATRIX IS ALREADY TRANSPOSED hardcoded HERE. 
    memory[8'h000F] <= 3;
    memory[8'h0010] <= 5;
    memory[8'h0011] <= 4;
    memory[8'h0012] <= 6;
  end

  // keep this the same --> combinational logic typically used for reading data to ensure immediate output when read is enabled. 
  always @(*) begin
    weight1 = memory[addr];
    weight2 = memory[addr + 1];
    weight3 = memory[addr + 2];
    weight4 = memory[addr + 3];
  end
endmodule
