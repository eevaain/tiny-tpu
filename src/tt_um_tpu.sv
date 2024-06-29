module tt_um_tpu (
    input wire [7:0] ui_in,      // Dedicated inputs
    output wire [7:0] uo_out,    // Dedicated outputs
    input wire [7:0] uio_in,     // IOs: Input path
    output wire [7:0] uio_out,   // IOs: Output path
    output wire [7:0] uio_oe,    // IOs: Enable path (active high: 0=input, 1=output)
    input wire ena,              // Will go high when the design is enabled
    input wire clk,              // Clock
    input wire rst_n             // Reset_n - low to reset
);

    wire rst = !rst_n;

    // Internal connections
    wire reset;
    wire [31:0] unified_mem [0:63];

    // Assign inputs and ouputs
    assign reset = rst;

    assign ui_in = 0; 
    assign uio_in = 0;

    // Bidir
    assign uio_out = 0;
    assign uio_oe  = 0;

    // Instantiate your main module
    main u_main (
        .clk(clk),
        .reset(reset),
        .unified_mem(unified_mem)
    );

    // Map the outputs
    assign uo_out[0] = unified_mem[0][0];
    assign uo_out[1] = unified_mem[0][1];
    assign uo_out[2] = unified_mem[0][2];
    assign uo_out[3] = unified_mem[0][3];
    assign uo_out[4] = unified_mem[0][4];
    assign uo_out[5] = unified_mem[0][5];
    assign uo_out[6] = unified_mem[0][6];
    assign uo_out[7] = unified_mem[0][7];

    // Unused bi-directional pins
    // assign uio_out = 8'b00000000;
    // assign uio_oe = 8'b00000000;

endmodule
