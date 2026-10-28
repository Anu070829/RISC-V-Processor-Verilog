module ControlUnit(
    input  [6:0] Opcode,

    output reg RegWrite,
    output reg ALUSrc,
    output reg MemRead,
    output reg MemWrite,
    output reg MemToReg,
    output reg Branch,
    output reg Jump,
    output reg [1:0] ALUOp
);

always @(*) begin

    // Default values
    RegWrite = 1'b0;
    ALUSrc   = 1'b0;
    MemRead  = 1'b0;
    MemWrite = 1'b0;
    MemToReg = 1'b0;
    Branch   = 1'b0;
    Jump     = 1'b0;
    ALUOp    = 2'b00;

    case (Opcode)

        // ------------------------------------
        // R-Type instructions
        // ADD, SUB, AND, OR, XOR, NOR, SLL,
        // SRL, SLT
        // Opcode = 0110011
        // ------------------------------------
        7'b0110011: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b0;
            MemRead  = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            Branch   = 1'b0;
            Jump     = 1'b0;
            ALUOp    = 2'b10;
        end


        // ------------------------------------
        // ADDI
        // Opcode = 0010011
        // ------------------------------------
        7'b0010011: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
            MemRead  = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            Branch   = 1'b0;
            Jump     = 1'b0;
            ALUOp    = 2'b11;
        end


        // ------------------------------------
        // LW
        // Opcode = 0000011
        // ------------------------------------
        7'b0000011: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
            MemRead  = 1'b1;
            MemWrite = 1'b0;
            MemToReg = 1'b1;
            Branch   = 1'b0;
            Jump     = 1'b0;
            ALUOp    = 2'b00;
        end


        // ------------------------------------
        // SW
        // Opcode = 0100011
        // ------------------------------------
        7'b0100011: begin
            RegWrite = 1'b0;
            ALUSrc   = 1'b1;
            MemRead  = 1'b0;
            MemWrite = 1'b1;
            MemToReg = 1'b0;
            Branch   = 1'b0;
            Jump     = 1'b0;
            ALUOp    = 2'b00;
        end


        // ------------------------------------
        // BEQ
        // Opcode = 1100011
        // ------------------------------------
        7'b1100011: begin
            RegWrite = 1'b0;
            ALUSrc   = 1'b0;
            MemRead  = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            Branch   = 1'b1;
            Jump     = 1'b0;
            ALUOp    = 2'b01;
        end


        // ------------------------------------
        // JAL
        // Opcode = 1101111
        // ------------------------------------
        7'b1101111: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b0;
            MemRead  = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            Branch   = 1'b0;
            Jump     = 1'b1;
            ALUOp    = 2'b00;
        end


        // ------------------------------------
        // Unsupported instruction
        // ------------------------------------
        default: begin
            RegWrite = 1'b0;
            ALUSrc   = 1'b0;
            MemRead  = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            Branch   = 1'b0;
            Jump     = 1'b0;
            ALUOp    = 2'b00;
        end

    endcase

end

endmodule