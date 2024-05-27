module ControlUnit (
    input wire clk,
    input wire rst,
    
    input wire [15:0] instruction,  // Instruction input (16-bit)
    output reg load,
    output reg store,
    output reg broadcast,
    output reg sync,
    output reg matmul,
    output reg add,
    output reg mul
); // dont think i need branching? 

    // Instruction decoding logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all control signals
            load <= 0;
            store <= 0;
            broadcast <= 0;
            sync <= 0;
            matmul <= 0;
            add <= 0;
            mul <= 0;
        end else begin
            // Decode the instruction
            case (instruction[15:13])  // Assuming 3-bit opcode
                3'b000: begin  // LD
                    load <= 1;
                    store <= 0;
                    broadcast <= 0;
                    sync <= 0;
                    matmul <= 0;
                    add <= 0;
                    mul <= 0;
                end
                3'b001: begin  // ST
                    load <= 0;
                    store <= 1;
                    broadcast <= 0;
                    sync <= 0;
                    matmul <= 0;
                    add <= 0;
                    mul <= 0;
                end
                3'b010: begin  // MATMUL
                    load <= 0;
                    store <= 0;
                    broadcast <= 0;
                    sync <= 0;
                    matmul <= 1;
                    add <= 0;
                    mul <= 0;
                end
                3'b011: begin  // ADD
                    load <= 0;
                    store <= 0;
                    broadcast <= 0;
                    sync <= 0;
                    matmul <= 0;
                    add <= 1;
                    mul <= 0;
                end
                3'b100: begin  // MUL
                    load <= 0;
                    store <= 0;
                    broadcast <= 0;
                    sync <= 0;
                    matmul <= 0;
                    add <= 0;
                    mul <= 1;
                end
                3'b101: begin  // BROADCAST
                    load <= 0;
                    store <= 0;
                    broadcast <= 1;
                    sync <= 0;
                    matmul <= 0;
                    add <= 0;
                    mul <= 0;
                end
                3'b110: begin  // SYNC
                    load <= 0;
                    store <= 0;
                    broadcast <= 0;
                    sync <= 1;
                    matmul <= 0;
                    add <= 0;
                    mul <= 0;
                end
                default: begin  // Default case to handle invalid instructions
                    load <= 0;
                    store <= 0;
                    broadcast <= 0;
                    sync <= 0;
                    matmul <= 0;
                    add <= 0;
                    mul <= 0;
                end
            endcase
        end
    end

endmodule

// reduced number of bits for opcode, can still use 8 opcodes within 3 bits cus of twos complement
// now i have 13 bits remaining. 