module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUSel,
    output reg [31:0] ALUResult,
    output Zero
);

always @(*) begin
    case(ALUSel)
        4'b0000: ALUResult = A + B;
        4'b0001: ALUResult = A - B;
        4'b0010: ALUResult = A & B;
        4'b0011: ALUResult = A | B;
        4'b0100: ALUResult = A ^ B;
        4'b0101: ALUResult = ~(A | B);
        4'b0110: ALUResult = A << B[4:0];
        4'b0111: ALUResult = A >> B[4:0];
        4'b1000: ALUResult = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
        default: ALUResult = 32'd0;
    endcase
end

assign Zero = (ALUResult == 32'd0);

endmodule 