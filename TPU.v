module TPU (
    input wire clk,
    input wire rst,
    input wire [31:0] instruction,
    // Other inputs and outputs
);

    // Control signals
    wire load, store, broadcast, sync, matmul, add, mul;

    // Instantiate the Control Unit
    ControlUnit cu (
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        .load(load), //output
        .store(store), //output
        .broadcast(broadcast), //output
        .sync(sync), //output 
        .matmul(matmul), //output
        .add(add), //output
        .mul(mul) //output
    );

    // Instantiate Systolic Array and Memory Interface
    // Add the rest of integration code here

endmodule
