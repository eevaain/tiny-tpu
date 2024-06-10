module control_unit (
  input clk,
  input reset,
  input [15:0] instruction,
  output reg load_weight,
  output reg [12:0] base_address
);

  always @(*) begin
    if (reset) begin
      base_address = 0;
      load_weight = 0;
    end else begin
      case (instruction[15:13])
        3'b000: begin  // LOAD_ADDR
          base_address = instruction[12:0];
          load_weight = 0;
        end
        3'b001: begin  // LOAD_WEIGHT
          load_weight = 1;
        end
        default: begin
          load_weight = 0;
        end
      endcase
    end
  end

endmodule
