`default_nettype none
`timescale 1ns/1ns

module input_setup(
    input wire clk,
    input wire reset,
    input wire valid,

    input wire [7:0] a11,
    input wire [7:0] a12,
    input wire [7:0] a21,
    input wire [7:0] a22,

    output reg [7:0] a_in1,
    output reg [7:0] a_in2
);
    // n + 1 cells for each row (to accommodate zero-padding)
    reg [7:0] augmented_activation_row1 [0:2];
    reg [7:0] augmented_activation_row2 [0:2];
    reg [2:0] counter;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 3; i = i + 1) begin
                augmented_activation_row1[i] <= 8'b0;
                augmented_activation_row2[i] <= 8'b0;
            end
            counter <= 3'b0;
            a_in1 <= 8'b0;
            a_in2 <= 8'b0;
        end else if (valid) begin
            if (counter == 0) begin
                augmented_activation_row1[0] <= a11;
                augmented_activation_row1[1] <= a12;
                augmented_activation_row1[2] <= 8'b0;

                augmented_activation_row2[0] <= 8'b0;
                augmented_activation_row2[1] <= a21;
                augmented_activation_row2[2] <= a22;
            end

            if (counter < 3) begin
                a_in1 <= augmented_activation_row1[counter];
                a_in2 <= augmented_activation_row2[counter];
                counter <= counter + 1;
            end else begin
                a_in1 <= 8'b0;
                a_in2 <= 8'b0;
            end
        end else begin
            a_in1 <= 8'b0;
            a_in2 <= 8'b0;
        end
    end

endmodule
