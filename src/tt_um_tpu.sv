`default_nettype none
`timescale 1ns/1ns

module tt_um_tpu (
    input  wire [7:0] ui_in,    // Dedicated inputs (make this data input)
    output wire [7:0] uo_out,   // Dedicated outputs

    // 8 physical pins 
    input  wire [7:0] uio_in,   // IOs: Input path (make this flag input)
    output wire [7:0] uio_out,  // IOs: Output path 
    
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       reset     // reset_n - low to reset
);
    reg [7:0] uio_oe_reg; 
    assign uio_oe = uio_oe_reg;

    reg fetch_w;
    reg fetch_inp; 
    reg fetch_ins; 
    reg start; 

    // make FSM for the fetches.


typedef enum reg [2:0] {
    IDLE = 3'b000, 
    FETCH_W = 3'b001, 
    FETCH_INP = 3'b010, 
    FETCH_INS = 3'b011,
    START = 3'b100
    } state_t; 

  state_t state = IDLE;

    always @(*) begin
        if (reset) begin
            fetch_w = 0; 
            fetch_inp = 0;
            fetch_ins = 0;
            start = 0;
            uio_oe_reg = 8'b0000_0000; // All pins as inputs initially
        end 

        // case (state)
        //     IDLE: begin 
        //         if (uio_in[7:5] == 3'b001) begin
        //             state = FETCH_W; 
        //         end else if (uio_in[7:5] == 3'b010) begin
        //             state = FETCH_INP; 
        //         end else if (uio_in[7:5] == 3'b011) begin
        //             state = FETCH_INS; 
        //         end else if (uio_in[7:5] == 3'b100) begin
        //             state = START; 
        //         end else begin
        //             state = IDLE; 
        //         end
        //     end
        //     FETCH_W: begin
        //         fetch_inp = 1; 
        //         fetch_inp = 0; 
        //         fetch_ins = 0;
        //         start = 0; 
        //         state = IDLE; 
        //     end
        //     FETCH_INP: begin
        //         fetch_inp = 0; 
        //         fetch_inp = 1; 
        //         fetch_ins = 0;
        //         start = 0; 
        //         state = IDLE; 
        //     end
        //     FETCH_INS: begin
        //         fetch_inp = 0; 
        //         fetch_inp = 0; 
        //         fetch_ins = 1;
        //         start = 0; 
        //         state = IDLE; 
        //     end   
        //     START: begin
        //         fetch_inp = 0; 
        //         fetch_inp = 0; 
        //         fetch_ins = 0;
        //         start = 1; 
        //         state = IDLE; 
        //     end 
        // endcase

       


        
        
        else begin
            fetch_w = 0; 
            fetch_inp = 0;
            fetch_ins = 0;
            start = 0;

            case (uio_in[7:5]) 
                3'b000: begin 
                    fetch_w = 0; 
                    fetch_inp = 0;
                    fetch_ins = 0;
                    start = 0;
                end
                3'b001: fetch_w = 1; 
                3'b010: fetch_inp = 1;
                3'b011: fetch_ins = 1; 
                3'b101: start = 1; 
                default: begin 
                    fetch_w = 0; 
                    fetch_inp = 0;
                    fetch_ins = 0;
                    start = 0;
                end
            endcase

        end
    end

endmodule