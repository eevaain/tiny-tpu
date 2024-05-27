module SystolicArray (
    input wire clk,
    input wire rst,
    input wire matmul_convolve,
    input wire [`DATA_W-1:0] data_in,
    input wire [`DATA_W-1:0] weights,
    output wire [`DATA_W-1:0] out
);
    parameter ARRAY_SIZE = 4; // Adjust as necessary

    wire [`DATA_W-1:0] x_internal [0:ARRAY_SIZE][0:ARRAY_SIZE-1];
    wire [`DATA_W-1:0] partial_sums [0:ARRAY_SIZE][0:ARRAY_SIZE-1];

    genvar i, j;
    generate
        for (i = 0; i < ARRAY_SIZE; i = i + 1) begin : row
            for (j = 0; j < ARRAY_SIZE; j = j + 1) begin : col
                if (j == 0) begin
                    assign x_internal[i][j] = data_in; // Initial input from data_in
                end else begin
                    assign x_internal[i][j] = x_internal[i][j-1]; // Data flow in rows
                end

                if (i == 0) begin
                    assign partial_sums[i][j] = 0; // Initial partial sum is zero for the first row
                end

                PE pe_inst (
                    .clk(clk),
                    .rst(rst),
                    .x_in(x_internal[i][j]),
                    .weight(weights), // Weight input from weights array
                    .partial_sum_in(partial_sums[i][j]),
                    .x_out(x_internal[i][j+1]), // Pass to the next PE in the row
                    .partial_sum_out(partial_sums[i+1][j]) // Pass to the next PE in the column
                );
            end
        end
    endgenerate

    generate
        for (j = 0; j < ARRAY_SIZE; j = j + 1) begin
            assign out = partial_sums[ARRAY_SIZE][j]; // Output the final sums
        end
    endgenerate
endmodule
