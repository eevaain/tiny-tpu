module PE (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] c
);
    reg [31:0] result;
    always @(posedge clk or posedge rst) begin
        if (rst) result <= 0;
        else result <= a * b;  // Change operation as needed
    end
    assign c = result;
endmodule
