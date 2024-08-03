`default_nettype none
`timescale 1ns/1ns

module dma ( 
    // INPUTS
    input clk, 
    input reset, 
    input wire [7:0] uio_in, 
    // OUPUTS
    output reg fetch_w,
    output reg fetch_inp,
    output reg fetch_ins,
    output reg start,
    output reg [3:0] dma_address
);

    always @(*) begin // might be smarter to change this block to be combinational. 
        if (reset) begin
            fetch_w = 0; 
            fetch_inp = 0;
            fetch_ins = 0;
            start = 0;
            dma_address = 0;
        end else begin
            fetch_w = 0; 
            fetch_inp = 0;
            fetch_ins = 0;
            start = 0;
            dma_address = 0; 
            // IMPORTANT ^^^ these are necessary to deassert flag if not "held." by host computer

            case (uio_in[7:5])
                3'b000: begin 
                    fetch_w = 0; 
                    fetch_inp = 0;
                    fetch_ins = 0;
                    start = 0;
                    dma_address = 0;
                end
                3'b001: begin 
                    fetch_w = 1; 
                    dma_address = uio_in[3:0];
                end
                3'b010: begin
                    fetch_inp = 1;
                    dma_address = uio_in[3:0];
                end
                3'b011: begin
                    fetch_ins = 1; 
                    dma_address = uio_in[3:0];
                end
                3'b100: begin
                    start = 1; 
                    dma_address = 0; 
                end
                default: begin 
                    fetch_w = 0; 
                    fetch_inp = 0;
                    fetch_ins = 0;
                    start = 0;
                    dma_address = 0;
                end
            endcase
        end
    end

endmodule