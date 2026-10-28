module RegisterFile(
    input clk,
    input RegWrite,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] ReadData2
);

reg [31:0] Registers [0:31];

assign ReadData1 = (rs1 == 5'd0) ? 32'd0 : Registers[rs1];
assign ReadData2 = (rs2 == 5'd0) ? 32'd0 : Registers[rs2];

always @(posedge clk) begin
    if (RegWrite && (rd != 5'd0))
        Registers[rd] <= WriteData;
end

endmodule