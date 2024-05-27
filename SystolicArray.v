module SystolicArray (
    input wire clk,
    input wire rst,
    input wire [31:0] in_a [0:ARRAY_SIZE-1],
    input wire [31:0] in_b [0:ARRAY_SIZE-1],
    output wire [31:0] out_c [0:ARRAY_SIZE-1]
);
    parameter ARRAY_SIZE = 4; // change if needed
    genvar i, j;
    generate
        for (i = 0; i < ARRAY_SIZE; i = i + 1) begin : row
            for (j = 0; j < ARRAY_SIZE; j = j + 1) begin : col
                wire [31:0] a, b, c;
                PE pe_inst (
                    .clk(clk),
                    .rst(rst),
                    .a(in_a[i]),
                    .b(in_b[j]),
                    .c(c)
                );
                assign out_c[i * ARRAY_SIZE + j] = c;
            end
        end
    endgenerate
endmodule
