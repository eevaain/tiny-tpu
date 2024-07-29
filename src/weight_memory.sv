`default_nettype none
`timescale 1ns/1ns

module weight_memory (
  input wire fetch_w, 
  input wire [7:0] ui_in, 

  input wire clk,
  input wire reset,
  input wire load_weight, 
  input wire [4:0] addr, // 5 bit address but only need 3 of those bits to address 8 cells. 
  output reg [7:0] weight1,
  output reg [7:0] weight2,
  output reg [7:0] weight3,
  output reg [7:0] weight4
);
  reg [7:0] memory [0:7]; // Simple memory to store weights (only 8 addresses)
  reg [3:0] memory_pointer; 
  integer i;

  typedef enum reg [1:0] {IDLE, READ_FROM_HOST} state_t; 
  state_t state = IDLE;
 
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      for (i = 0; i < 8; i++) begin
        memory[i] <= 8'b0;
      end
      weight1 <= 8'b0;
      weight2 <= 8'b0;
      weight3 <= 8'b0;
      weight4 <= 8'b0;

      memory_pointer <= 3'b0; 
      state <= IDLE; 

    end else if (load_weight) begin // WRITE DATA
      weight1 <= memory[addr];
      weight2 <= memory[addr + 1];
      weight3 <= memory[addr + 2];
      weight4 <= memory[addr + 3];
    end else begin

        case (state)
          IDLE: begin
              state <= IDLE;
              if (fetch_w) begin // if fetch_w flag is enabled. 
                state <= READ_FROM_HOST; 
              end
          end
          READ_FROM_HOST: begin
            if (memory_pointer < 4) begin // could be delay issues from jumping immediateely to this state. may need to manually add another delay to fix the timing? 
              memory[memory_pointer] <= ui_in; // memory pointer will always start from the first address
              memory_pointer <= memory_pointer + 1; 
            end else begin
              state <= IDLE; 
            end
          end
        endcase


    end
  end
endmodule
