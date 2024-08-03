`default_nettype none
`timescale 1ns/1ns

// This module is literally just a wrapper to ensure i meet tinytapeout specifications. 

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
    // wire reset = ~rst_n;
    assign uio_oe  = 8'b0000_0000;

    tpu tpu (
    // INPUTS
    .clk(clk),
    .reset(reset),
    .ui_in(ui_in), 
    .uio_in(uio_in), 
     // OUTPUTS
    .uo_out(uo_out) 
    ); 

endmodule