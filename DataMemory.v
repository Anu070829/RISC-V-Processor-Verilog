module DataMemory(
    input clk,
    input MemRead,
    input MemWrite,
    input [31:0] Address,
    input [31:0] WriteData,
    output reg [31:0] ReadData
);

reg [31:0] Memory [0:255];

integer i;

initial begin
    for(i = 0; i < 256; i = i + 1)
        Memory[i] = 32'd0;
end

always @(posedge clk) begin
    if (MemWrite)
        Memory[Address[9:2]] <= WriteData;
end

always @(*) begin
    if (MemRead)
        ReadData = Memory[Address[9:2]];
    else
        ReadData = 32'd0;
end

endmodule