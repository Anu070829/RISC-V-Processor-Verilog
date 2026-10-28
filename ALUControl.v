module ALUControl(
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input        funct7,
    output reg [3:0] ALUSel
);

always @(*) begin

    case (ALUOp)

        // --------------------------------
        // LW / SW / JAL
        // ALU performs ADD
        // --------------------------------
        2'b00: begin
            ALUSel = 4'b0000;
        end


        // --------------------------------
        // BEQ
        // ALU performs SUB
        // --------------------------------
        2'b01: begin
            ALUSel = 4'b0001;
        end


        // --------------------------------
        // R-Type instructions
        // --------------------------------
        2'b10: begin

            case (funct3)

                // ADD / SUB
                3'b000: begin
                    if (funct7 == 1'b1)
                        ALUSel = 4'b0001;   // SUB
                    else
                        ALUSel = 4'b0000;   // ADD
                end

                // SLL
                3'b001: begin
                    ALUSel = 4'b0110;
                end

                // SLT
                3'b010: begin
                    ALUSel = 4'b1000;
                end

                // XOR
                3'b100: begin
                    ALUSel = 4'b0100;
                end

                // SRL
                3'b101: begin
                    ALUSel = 4'b0111;
                end

                // OR
                3'b110: begin
                    ALUSel = 4'b0011;
                end

                // AND
                3'b111: begin
                    ALUSel = 4'b0010;
                end

                default: begin
                    ALUSel = 4'b0000;
                end

            endcase

        end


        // --------------------------------
        // ADDI
        // ALU performs ADD
        // --------------------------------
        2'b11: begin
            ALUSel = 4'b0000;
        end


        default: begin
            ALUSel = 4'b0000;
        end

    endcase

end

endmodule
