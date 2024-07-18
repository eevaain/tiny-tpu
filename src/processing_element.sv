`default_nettype none
`timescale 1ns/1ns

module processing_element (
  input wire clk,
  input wire reset,
  input wire load_weight,       // Signal to load weight
  input wire valid,             // Valid signal indicating new data is available

  input wire [7:0] a_in,       // Input A from left neighbor
  input wire [7:0] weight,     // Weight input
  input wire [7:0] acc_in,     // Accumulated value from the PE above

  output reg [7:0] a_out,    // Output A to right neighbor
  output reg [7:0] acc_out   // Accumulated value to the PE below
);

  reg [7:0] weight_reg; // Register to hold the stationary weight

  // State definitions
  typedef enum reg [1:0] {IDLE, LOAD_WEIGHT, COMPUTE} state_t;
  state_t state;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      a_out <= 8'b0;
      acc_out <= 8'b0;
      weight_reg <= 8'b0;
      state <= IDLE;
    end else begin
      case (state)
        IDLE: begin
          if (load_weight) begin
            state <= LOAD_WEIGHT;
          end else if (valid) begin
            state <= COMPUTE;
          end
        end

        LOAD_WEIGHT: begin
          weight_reg <= weight;
          state <= IDLE; // Return to IDLE after loading weight
        end

        COMPUTE: begin
          acc_out <= acc_in + (a_in * weight_reg);
          a_out <= a_in;
          state <= IDLE; // Return to IDLE after computation
        end

      endcase
    end
  end
endmodule
