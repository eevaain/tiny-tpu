module SystolicArray #(
    parameter N = `N
    parameter DATA_WIDTH = `DATA_W
)(
    input wire clk,
    input wire rst,
    input wire matmul,  // Control signal for matrix multiplication
    input wire [DATA_WIDTH-1:0] a [N-1:0][N-1:0],  // Input matrix A
    input wire [DATA_WIDTH-1:0] b [N-1:0][N-1:0],  // Input matrix B
    output reg [(2*DATA_WIDTH)-1:0] c [N-1:0][N-1:0]  // Output matrix C
);

    // Internal wires for interconnecting PEs
    wire [DATA_WIDTH-1:0] x_inter [N-1:0][N:0];  // x_in and x_out connections for each PE
    wire [DATA_WIDTH-1:0] y_inter [N:0][N-1:0];  // y_in and y_out connections for each PE
    wire [2*DATA_WIDTH-1:0] partial_sums [N-1:0][N-1:0]; // Partial sum connections

    genvar i, j;
    generate
        for (i = 0; i < N; i = i + 1) begin : row
            for (j = 0; j < N; j = j + 1) begin : col
                PE #(
                    .DATA_WIDTH(DATA_WIDTH)
                ) pe_inst (
                    .clk(clk),
                    .rst(rst),
                    .x_in(x_inter[i][j]),
                    .y_in(y_inter[i][j]),
                    .partial_sum_in((j == 0) ? 0 : partial_sums[i][j-1]),
                    .x_out(x_inter[i][j+1]),
                    .y_out(y_inter[i+1][j]),
                    .partial_sum_out(partial_sums[i][j])
                );
            end
        end
    endgenerate

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < N; i = i + 1) begin
                for (int j = 0; j < N; j = j + 1) begin
                    c[i][j] <= 0;
                end
            end
        end else if (matmul) begin
            // Load inputs into internal wires
            for (int i = 0; i < N; i = i + 1) begin
                x_inter[i][0] <= a[i][0];
                y_inter[0][i] <= b[0][i];
            end

            // Store results from partial sums
            for (int i = 0; i < N; i = i + 1) begin
                for (int j = 0; j < N; j = j + 1) begin
                    c[i][j] <= partial_sums[i][j];
                end
            end
        end
    end
endmodule
