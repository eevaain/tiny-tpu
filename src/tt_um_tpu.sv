`default_nettype none
`timescale 1ns/1ns

module tt_um_tpu (
    input  wire [7:0] ui_in,    // Dedicated inputs (make this data input)
    output wire [7:0] uo_out,   // Dedicated outputs

    // 8 physical pins 
    input  wire [7:0] uio_in,   // IOs: Input path (make this flag input)
    output wire [7:0] uio_out,  // IOs: Output path 
    
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       reset     // rst_n - low to reset --> // TODO: rename back to rst_n!
);
    assign uio_oe  = 8'b0000_0000;

    // wire reset = ~rst_n

    reg fetch_w;
    reg fetch_inp; 
    reg fetch_ins; 
    reg start; 

    // TODO: make another always block to decode address from uio_in? (concurrent task from below)

    always @(posedge clk or posedge reset) begin // might be smarter to change this block to be combinational. 
        if (reset) begin
            fetch_w <= 0; 
            fetch_inp <= 0;
            fetch_ins <= 0;
            start <= 0;
            // uio_oe_reg <= 8'b0000_0000; // Set birectional pins as hardcoded inputs
        end else begin
            fetch_w <= 0; 
            fetch_inp <= 0;
            fetch_ins <= 0;
            start <= 0;


            case (uio_in[7:5]) // TODO: Decode address (5 bit) so that data can do go specific address of memory
                3'b000: begin 
                    fetch_w <= 0; 
                    fetch_inp <= 0;
                    fetch_ins <= 0;
                    start <= 0;
                end
                3'b001: fetch_w <= 1; 
                3'b010: fetch_inp <= 1;
                3'b011: fetch_ins <= 1; 
                3'b100: start <= 1; 
                default: begin 
                    fetch_w <= 0; 
                    fetch_inp <= 0;
                    fetch_ins <= 0;
                    start <= 0;
                end
            endcase
        end
    end

    tpu tpu (
    // INPUTS
    .clk(clk),
    .reset(reset),
    .ui_in(ui_in), 
     // Data select flags
    .start(start),  // flag to start the program
    .fetch_w(fetch_w), // flag to fetch weights from host
    .fetch_inp(fetch_inp), // flag to fetch inputs from host
    .fetch_ins(fetch_ins), // flag to fetch instructions from host
     // OUTPUTS
    .wire_out(uo_out) 
    ); 

endmodule