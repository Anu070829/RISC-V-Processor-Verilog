module ImmediateGenerator(
    input  [31:0] Instruction,
    output reg [31:0] Immediate
);

always @(*) begin

    case (Instruction[6:0])

        // I-Type: ADDI, LW
        7'b0010011,
        7'b0000011: begin
            Immediate = {{20{Instruction[31]}},
                         Instruction[31:20]};
        end

        // S-Type: SW
        7'b0100011: begin
            Immediate = {{20{Instruction[31]}},
                         Instruction[31:25],
                         Instruction[11:7]};
        end

        // B-Type: BEQ
        7'b1100011: begin
            Immediate = {{19{Instruction[31]}},
                         Instruction[31],
                         Instruction[7],
                         Instruction[30:25],
                         Instruction[11:8],
                         1'b0};
        end

        // J-Type: JAL
        7'b1101111: begin
            Immediate = {{11{Instruction[31]}},
                         Instruction[31],
                         Instruction[19:12],
                         Instruction[20],
                         Instruction[30:21],
                         1'b0};
        end

        default: begin
            Immediate = 32'b0;
        end

    endcase

end

endmodule