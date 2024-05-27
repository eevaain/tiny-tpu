/*
This module can read weights from an external memory...
... and make them available to the systolic array.

*/


module MemoryInterface (
    input wire clk,
    input wire rst,
    input wire [31:0] addr,
    input wire [31:0] data_in,
    output wire [31:0] data_out,
    input wire load,
    input wire store
);
    reg [31:0] memory [0:MEMORY_SIZE-1];
    
    always @(posedge clk) begin
        if (load) data_out <= memory[addr];
        if (store) memory[addr] <= data_in;
    end
endmodule
