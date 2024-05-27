module ControlUnit (
    input wire clk,
    input wire rst,
    input wire [15:0] instruction,  // Instruction input (16-bit)
    
    output reg load,
    output reg store,
    output reg matmul,
    output reg broadcast
); 

    // Instruction decoding logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all control signals
            load <= 0;
            store <= 0;
            matmul <= 0;
            broadcast <= 0;
        end else begin
            // Decode the instruction
            case (instruction[15:13])  // Assuming 3-bit opcode
                3'b000: begin  // Read_Host_Memory (load)
                    load <= 1;
                    store <= 0;
                    matmul <= 0;
                    broadcast <= 0;
                end
                3'b001: begin  // Read_Weights (broadcast)
                    load <= 0;
                    store <= 0;
                    matmul <= 0;
                    broadcast <= 1;
                end
                3'b010: begin  // MatrixMultiply/Convolve (matmul)
                    load <= 0;
                    store <= 0;
                    matmul <= 1;
                    broadcast <= 0;
                end
                3'b011: begin  // Write_Host_Memory (store)
                    load <= 0;
                    store <= 1;
                    matmul <= 0;
                    broadcast <= 0;
                end
                default: begin  // Default case to handle invalid instructions
                    load <= 0;
                    store <= 0;
                    matmul <= 0;
                    broadcast <= 0;
                end
            endcase
        end
    end
endmodule
