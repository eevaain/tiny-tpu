`define DATA_W 16
`define N 2

module MemoryInterface #(
    parameter N = `N
    parameter DATA_WIDTH = `DATA_W
)(
    input wire clk,
    input wire rst,
    input wire [$clog2(N*N)-1:0] addr_top,  // Address for top matrix
    input wire [$clog2(N*N)-1:0] addr_left, // Address for left matrix
    input wire [DATA_WIDTH-1:0] data_in,  // Data input for store operation
    input wire load,                // Load control signal
    input wire store,               // Store control signal

    output reg [DATA_WIDTH-1:0] data_out_top [N-1:0],  // Data output for top matrix
    output reg [DATA_WIDTH-1:0] data_out_left [N-1:0]  // Data output for left matrix
);

    // Memory for top and left matrices with sufficient size for NxN elements
    reg [DATA_WIDTH-1:0] host_memory_top [0:N*N-1];  
    reg [DATA_WIDTH-1:0] host_memory_left [0:N*N-1]; 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < N; i = i + 1) begin
                data_out_top[i] <= 0;
                data_out_left[i] <= 0;
            end
        end else begin
            if (load) begin
                for (int i = 0; i < N; i = i + 1) begin
                    data_out_top[i] <= host_memory_top[addr_top + i];  // Read data from top matrix memory
                    data_out_left[i] <= host_memory_left[addr_left + i];  // Read data from left matrix memory
                end
            end
            if (store) begin
                for (int i = 0; i < N; i = i + 1) begin
                    host_memory_top[addr_top + i] <= data_in;  // Store data_in to top memory
                    host_memory_left[addr_left + i] <= data_in; // Store data_in to left memory
                end
            end
        end
    end
endmodule
