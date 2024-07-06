module input_setup(
    input clk,
    input reset,
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

    always @(*) begin
        if (valid && counter == 0) begin 
            augmented_activation_row1[0] = a11;
            augmented_activation_row1[1] = a12;
            augmented_activation_row1[2] = 0;

            augmented_activation_row2[0] = 0; // Initialize first element to zero for padding
            augmented_activation_row2[1] = a21;
            augmented_activation_row2[2] = a22;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 3; i = i + 1) begin
                augmented_activation_row1[i] <= 0;
                augmented_activation_row2[i] <= 0;
            end
            counter <= 0; 
            a_in1 <= 0;
            a_in2 <= 0; 

        end else if (valid && counter < 3) begin
            a_in1 <= augmented_activation_row1[counter];
            a_in2 <= augmented_activation_row2[counter];
            counter <= counter + 1; // IMPORTANT takes prev value (like js prev) 
        end else begin
            // Output zeros when counter exceeds valid range
            a_in1 <= 0;
            a_in2 <= 0;
        end
    end
endmodule
