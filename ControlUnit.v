module ControlUnit (
    input wire clk,
    input wire rst,
    input wire [15:0] instruction,  // Instruction input (16-bit)
    
    output reg load,                // Assembly flag bit for load operation
    output reg store,               // Assembly flag bit for store operation
    output reg matmul               // Assembly flag bit for matrix multiply operation
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all control signals
            load <= 0;
            store <= 0;
            matmul <= 0;
        end else begin
            // Decode the instruction
            case (instruction[15:13])  // Assuming 3-bit opcode
                3'b000: begin  // No-Op
                    load <= 0;
                    store <= 0;
                    matmul <= 0;
                end
                3'b001: begin  // Read_Host_Memory (load)
                    load <= 1;    // Set load signal based on assembly instruction
                    store <= 0;
                    matmul <= 0;
                end
                3'b010: begin  // Write_Host_Memory (store)
                    load <= 0;
                    store <= 1;   // Set store signal based on assembly instruction
                    matmul <= 0;
                end
                3'b011: begin  // MatrixMultiply/Convolve (matmul)
                    load <= 0;
                    store <= 0;
                    matmul <= 1;  // Set matmul signal based on assembly instruction
                end
                default: begin  // Default case to handle invalid instructions
                    load <= 0;
                    store <= 0;
                    matmul <= 0;
                end
            endcase
        end
    end
endmodule
