module control_unit (
  input clk,
  input reset,
  input [15:0] instruction,
  output reg load_weight,
  output reg [12:0] base_address,
  output reg load_input,
  output reg valid
  // perhaps create a flag for selecting between weight memory or activation memory
);

  always @(*) begin
    if (reset) begin
      base_address <= 0;
      load_weight <= 0;
    end else begin
      case (instruction[15:13])
        3'b001: begin  // LOAD_ADDR
          base_address <= instruction[12:0];
          load_weight <= 0;
        end
        3'b010: begin  // LOAD_WEIGHT
          load_weight = 1;
        end
        3'b011: begin // LOAD INPUTS
          load_input = 1; 
        end
        3'b100: begin // VALID (cmpute) (maybe should rename to valid)
          valid = 1; 
        end
        default: begin
          load_weight = 0;
        end
      endcase
    end
  end

endmodule
