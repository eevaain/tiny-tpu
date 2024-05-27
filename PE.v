module PE (
    input wire clk,
    input wire rst,
    input wire [`DATA_W-1:0] x_in,      // Activation input
    input wire [`DATA_W-1:0] weight,    // Weight input
    input wire [`DATA_W-1:0] partial_sum_in, // Partial sum input
    output reg [`DATA_W-1:0] x_out,     // Activation output to next PE
    output reg [`DATA_W-1:0] partial_sum_out // Partial sum output to next PE
);
    wire [`DATA_W-1:0] mul_result;
    wire [`DATA_W-1:0] add_result;

    // Multiply activation by weight
    assign mul_result = x_in * weight;
    
    // Add the result to the incoming partial sum
    assign add_result = partial_sum_in + mul_result;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_out <= 0;
            partial_sum_out <= 0;
        end else begin
            x_out <= x_in;            // Pass activation to the next PE
            partial_sum_out <= add_result; // Output the accumulated partial sum
        end
    end
endmodule
