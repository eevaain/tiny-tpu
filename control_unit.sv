module control_unit (
  input clk,
  input reset,
  input [15:0] instruction,
  output reg load_weight,
  output reg [12:0] base_address,
  output reg load_input,
  output reg valid,
  output reg store
);

  // ISA Control
  always @(*) begin
    if (reset) begin
      base_address <= 0;
      load_weight <= 0;
      load_input <= 0;
      valid <= 0;
      store <= 0; 
    end else begin
      // Default values for unused flags
      base_address <= base_address;
      load_weight <= 0;
      load_input <= 0;
      valid <= 0;
      store <= 0; 

      case (instruction[15:13])
        3'b001: begin  // LOAD_ADDR
          base_address <= instruction[12:0];
        end
        3'b010: begin  // LOAD_WEIGHT
          load_weight <= 1;
        end
        3'b011: begin // LOAD_INPUTS
          load_input <= 1; 
        end
        3'b100: begin // VALID (compute)
          valid <= 1; 
        end
          3'b101: begin // STORE
          store <= 1; 
        end
        default: begin
          // All flags are already zeroed by default
        end
      endcase
    end
  end

  // Program Counter Control

endmodule
