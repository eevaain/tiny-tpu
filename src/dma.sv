`default_nettype none
`timescale 1ns/1ns

module dma ( 
    // INPUTS
    input clk, 
    input reset, 
    input wire [7:0] uio_in, 
    input wire [7:0] ui_in, // TODO: delete this later
    // OUTPUTS
    output wire fetch_w,
    output wire fetch_inp,
    output wire fetch_ins,
    output wire start,
    output wire [3:0] dma_address
);

    // Internal register
    reg [7:0] test_storage [0:4];
    integer i;

    // Combinational logic for outputs
    assign fetch_w = uio_in[7:5] == 3'b001 ? 1 : 0;
    assign fetch_inp = uio_in[7:5] == 3'b010 ? 1 : 0;
    assign fetch_ins = uio_in[7:5] == 3'b011 ? 1 : 0;  
    assign start = uio_in[7:5] == 3'b100 ? 1 : 0;   
    assign dma_address = uio_in[3:0];


    // TODO: delete this later?
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 5; i = i + 1) begin
                test_storage[i] <= 8'b0;
            end
        end else if (fetch_w) begin
            test_storage[dma_address] <= ui_in;
        end
    end

endmodule
