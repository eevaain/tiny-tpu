`default_nettype none
`timescale 1ns/1ns

module control_unit (
  input wire fetch_ins,
  input wire [7:0] ui_in, 

  input wire clk,
  input wire reset,
  input wire start,          
  output reg [12:0] base_address,
  output reg load_input,
  output reg load_weight,
  output reg valid,
  output reg store,
  output reg ext
);

  // Instruction definitions
  localparam [7:0] NO_OP = 16'b000_00000;
  localparam [7:0] LOAD_ADDR = 16'b001_00000;
  localparam [7:0] LOAD_WEIGHT = 16'b010_00000;
  localparam [7:0] LOAD_INPUTS = 16'b011_00000;
  localparam [7:0] COMPUTE = 16'b100_00000;
  localparam [7:0] STORE = 16'b101_00000;
  localparam [7:0] EXT = 16'b111_000000;

  // FSM states for interal instruction dispatch
  typedef enum reg [1:0] {IDLE, FETCH, EXECUTE, FINISH} state_t;
  state_t state = IDLE;
  
  // FSM states for fetching data from an external computer
  typedef enum reg [1:0] {RFM_IDLE, READ_FROM_HOST} state_j; 
  state_j state_rfm = RFM_IDLE;
  reg [3:0] memory_pointer; 
  
  // Instruction memory
  reg [7:0] instruction_mem [0:9]; // Adjust the size as needed.
  reg [7:0] instruction;           // Instruction register

  integer instruction_pointer;
  integer compute_cycle_counter;    // Counter for compute cycles

  always @(posedge clk or posedge reset) begin 
      if (reset) begin
        state_rfm <= RFM_IDLE; 
        memory_pointer <= 0; 
      end else begin
      case (state_rfm)
          RFM_IDLE: begin
            state_rfm <= RFM_IDLE;
              if (fetch_ins) begin // if fetch_w flag is enabled. 
                state_rfm <= READ_FROM_HOST; 
              end
            end
          READ_FROM_HOST: begin
              if (memory_pointer < 10) begin // could be delay issues from jumping immediateely to this state. may need to manually add another delay to fix the timing? 
                instruction_mem[memory_pointer] <= ui_in; // memory pointer will always start from the first address
                memory_pointer <= memory_pointer + 1; 
              end else begin
                state_rfm <= RFM_IDLE; 
              end
            end
          endcase
        end
    end
    // Instruction decoding and control signal generation block
  always @(*) begin
      if (reset) begin
        base_address = 0;
        load_weight = 0;
        load_input = 0;
        valid = 0;
        store = 0;
        ext = 0;
        // instruction = 0;
      end else begin
          load_weight = 0; // clears register for this flag so its only on for two cycles
          load_input = 0;
          ext = 0;
          store = 0; 
        // Dispatch
        case (instruction[7:5])
          3'b001: base_address = instruction[4:0]; // LOAD_ADDR
          3'b010: load_weight = 1;                   // LOAD_WEIGHT
          3'b011: load_input = 1;                    // LOAD_INPUTS
          3'b100: valid = 1;                         // VALID (COMPUTE)
          3'b101: store = 1;                         // STORE
          3'b111: ext = 1;                      
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
      instruction <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (start) state <= FETCH;
        end
        FETCH: begin
          instruction <= instruction_mem[instruction_pointer];
          state <= EXECUTE;
        end
        EXECUTE: begin // Program is running here!
          case (instruction)
            COMPUTE: begin
              if (compute_cycle_counter < 4) begin
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
        FINISH: begin // triggered on NOP instruction
          // valid <= 0; // i want to add this but gotta keep blocking and non blocking mutually excl.
          state <= FINISH;
        end
        default: state <= IDLE;
      endcase
    end
  end
  
endmodule
