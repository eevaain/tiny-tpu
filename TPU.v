/*
This is the highest level module
*/

module TPU (
    input wire clk,
    input wire rst,
    input wire [15:0] instruction,
    input wire [`DATA_W-1:0] matrix_top [0:ARRAY_SIZE-1],  // Direct input for top matrix
    input wire [`DATA_W-1:0] matrix_left [0:ARRAY_SIZE-1]  // Direct input for left matrix
);

    wire load, store, matmul;
    wire [`DATA_W-1:0] data_in, data_out_top, data_out_left;

    // Instantiate Control Unit
    ControlUnit cu (
        // inputs
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        // outputs
        .load(load),
        .store(store), 
        .matmul(matmul)
    );

    // Instantiate Memory Interface
    MemoryInterface mi (
        // inputs
        .clk(clk),
        .rst(rst),
        .matrix_top(matrix_top),     // Direct input for top matrix
        .matrix_left(matrix_left),   // Direct input for left matrix
        .data_in(data_in),
        .load(load),  // Single load signal for both matrices
        .store(store),
        // outputs
        .data_out_top(data_out_top), 
        .data_out_left(data_out_left)
    );

    // Instantiate Systolic Array
    SystolicArray sa (
        // inputs
        .clk(clk),
        .rst(rst),
        .data_in_top(data_out_top), 
        .data_in_left(data_out_left), 
        .matmul_convolve(matmul),
        // output
        .out(data_in)  // Resulting data to be stored in memory
    );

endmodule
