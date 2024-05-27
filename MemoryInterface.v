/*
This module can read weights from an external memory...
... and make them available to the systolic array.

*/

module MemoryInterface (
    input wire clk,
    input wire rst,
    input wire [15:0] addr,
    input wire [`DATA_W-1:0] data_in,
    input wire load,             // Read from host memory
    input wire store,            // Write to host memory
    input wire read_weights,     // Read weights from weight memory

    output reg [`DATA_W-1:0] data_out,
    output reg [`DATA_W-1:0] weight_out
);
    reg [`DATA_W-1:0] host_memory [0:1023];  // Example memory size
    reg [`DATA_W-1:0] weight_memory [0:255]; // Example weight memory size

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 0;
            weight_out <= 0;
        end else begin
            if (load) begin
                data_out <= host_memory[addr];  // Read data from host memory
            end
            if (store) begin
                host_memory[addr] <= data_in;  // Write data to host memory
            end
            if (read_weights) begin
                weight_out <= weight_memory[addr];  // Read weights from weight memory
            end
        end
    end
endmodule




