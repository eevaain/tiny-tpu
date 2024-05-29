module PE #(
    parameter DATA_W = `DATA_W
)(
    input wire clk,
    input wire rst,
    input wire [`DATA_W-1:0] x_in,         // Activation input
    input wire [`DATA_W-1:0] y_in,         // New input for vertical data flow
    input wire [2*`DATA_W-1:0] partial_sum_in, // Partial sum input
    output reg [`DATA_W-1:0] x_out,        // Activation output to next PE
    output reg [`DATA_W-1:0] y_out,        // New output for vertical data flow
    output reg [2*`DATA_W-1:0] partial_sum_out // Partial sum output to next PE
);

    wire [2*`DATA_W-1:0] mul_result;
    wire [2*`DATA_W-1:0] add_result;

    assign mul_result = x_in * y_in;
    assign add_result = partial_sum_in + mul_result;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_out <= 0;
            y_out <= 0;
            partial_sum_out <= 0;
        end else begin
            x_out <= x_in;                 // Pass activation to the next PE in the row
            y_out <= y_in;                 // Pass vertical data to the next PE in the column
            partial_sum_out <= add_result; // Output the accumulated partial sum
        end
    end
endmodule
