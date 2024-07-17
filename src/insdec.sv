`default_nettype none
`timescale 1ns/1ns


module insdec(
    input wire [15:0] instruction,
    output reg [12:0] base_address,
    output reg load_weight,
    output reg load_input, 
    output reg valid,
    output reg store
);

  always @(*) begin
      // These overwrite the dispatched signals on next clock cycle 
      load_weight = 0;
      load_input = 0;
      valid = 0;
      store = 0;
      base_address = 0;

      case (instruction[15:13])
        3'b001: base_address = instruction[12:0]; // LOAD_ADDR
        3'b010: load_weight = 1;                   // LOAD_WEIGHT
        3'b011: load_input = 1;                    // LOAD_INPUTS
        3'b100: valid = 1;                         // VALID (COMPUTE)
        3'b101: store = 1;                         // STORE
        default: ; // NO_OP or unrecognized instruction
      endcase
    end


endmodule