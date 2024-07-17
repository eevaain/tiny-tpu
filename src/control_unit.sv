`default_nettype none
`timescale 1ns/1ns

module control_unit (
  input wire clk,
  input wire reset,
  input wire start,                 // New input to start the program
  output reg load_weight,
  output reg [12:0] base_address,
  output reg load_input,
  output reg valid,
  output reg store
);

  // Instruction definitions
  localparam [15:0] NO_OP = 16'b000_0000000000000;
  localparam [15:0] LOAD_ADDR = 16'b001_0000000000000;
  localparam [15:0] LOAD_WEIGHT = 16'b010_0000000000000;
  localparam [15:0] LOAD_INPUTS = 16'b011_0000000000000;
  localparam [15:0] COMPUTE = 16'b100_0000000000000;
  localparam [15:0] STORE = 16'b101_0000000000000;

  // FSM states
  typedef enum reg [1:0] {IDLE, FETCH, EXECUTE, FINISH} state_t;
  state_t state = IDLE;

  // Instruction memory
  reg [15:0] instruction_mem [0:7]; // Adjust the size as needed.
  reg [15:0] instruction;           // Instruction register

  integer instruction_pointer;
  integer compute_cycle_counter;    // Counter for compute cycles

    // Instruction decoding and control signal generation block
  always @(*) begin
      if (reset) begin
        base_address = 0;
        load_weight = 0;
        load_input = 0;
        valid = 0;
        store = 0;
      end else begin
        // Dispatch
        case (instruction[15:13])
          3'b001: base_address = instruction[12:0]; // LOAD_ADDR
          3'b010: load_weight = 1;                   // LOAD_WEIGHT
          3'b011: load_input = 1;                    // LOAD_INPUTS
          3'b100: valid = 1;                         // VALID (COMPUTE)
          3'b101: store = 1;                         // STORE
          default: ; // NO_OP or unrecognized instruction
        endcase
      end
    end

  // State transition and instruction execution block
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      instruction_pointer <= 0;
      compute_cycle_counter <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (start) state <= FETCH;
        end
        FETCH: begin
          instruction <= instruction_mem[instruction_pointer];
          state <= EXECUTE;
        end
        EXECUTE: begin
          case (instruction)
            COMPUTE: begin
              if (compute_cycle_counter < 3) begin
                compute_cycle_counter <= compute_cycle_counter + 1;
              end else begin
                compute_cycle_counter <= 0;
                instruction_pointer <= instruction_pointer + 1;
                state <= FETCH;
              end
            end
            NO_OP: state <= FINISH;
            default: begin
              instruction_pointer <= instruction_pointer + 1;
              state <= FETCH;
            end
          endcase
        end
        FINISH: state <= FINISH;
        default: state <= IDLE;
      endcase
    end
  end
  
endmodule
