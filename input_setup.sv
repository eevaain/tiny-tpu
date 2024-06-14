module input_setup(
    input clk,
    input reset,
    input valid, 

    input [31:0] a11,
    input [31:0] a12, 
    input [31:0] a21,
    input [31:0] a22,

    output reg [15:0] a_in1,
    output reg [15:0] a_in2
); 
    // n + 1 cells for each row (to accommodate zero-padding)
    reg [31:0] augmented_activation_row1 [0:2]; 
    reg [31:0] augmented_activation_row2 [0:2];

    reg [2:0] counter;

    integer i; 

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
      

                if (counter == 0) begin 
                    augmented_activation_row1[0] = a11;
                    augmented_activation_row1[1] = a12;
                    augmented_activation_row1[2] = 0;

                    augmented_activation_row2[0] = 0; // Initialize first element to zero for padding
                    augmented_activation_row2[1] = a21;
                    augmented_activation_row2[2] = a22;
                end
                // Output the values to a_in1 and a_in2
                // If you want to assign values to a signal within an always block, that signal must be declared as reg
                a_in1 <= augmented_activation_row1[counter];
                a_in2 <= augmented_activation_row2[counter];

                // Display the value of counter and augmented_activation_row values for debugging
                // $display("At time %t, counter = %d", $time, counter);
                // $display("augmented_activation_row1[%d] = %d", counter, augmented_activation_row1[counter]);
                // $display("augmented_activation_row2[%d] = %d", counter, augmented_activation_row2[counter]);

                counter <= counter + 1; 
         
        end
            else begin
                // Output zeros when counter exceeds valid range
                a_in1 <= 0;
                a_in2 <= 0;
            end
    end
endmodule
