/* 
This is the highest level module
*/

module TPU (
    input wire clk,
    input wire rst,
    input wire [15:0] instruction
);

    wire load, store, matmul, broadcast;
    wire [15:0] addr, data_in, data_out, weight_out;

    // Instantiate Control Unit
    ControlUnit cu (
        // inputs
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        // outputs
        .load(load),
        .store(store), 
        .matmul(matmul),  
        .broadcast(broadcast)
    );

    // Instantiate Memory Interface
        MemoryInterface mi (
        // inputs
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .data_in(data_in),
        .load(load),
        .store(store),
        .read_weights(broadcast),
        // outputs
        .data_out(data_out), 
        .weight_out(weight_out)
    );

    // Instantiate Systolic Array
    SystolicArray sa (
        // inputs
        .clk(clk),
        .rst(rst),
        .matmul_convolve(matmul),
        .data_in(data_out), 
        .weights(weight_out), 
        // output
        .out(data_in)
    );

endmodule

