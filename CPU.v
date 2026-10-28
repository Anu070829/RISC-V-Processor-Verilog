module CPU(
    input clk,
    input reset
);

    // =========================================================
    // PC signals
    // =========================================================

    wire [31:0] PC;
    wire [31:0] PCNext;

    wire[31:0] Immediate;

    wire [31:0] PCPlus4;
    wire [31:0] BranchTarget;
    wire [31:0] JumpTarget;

    assign PCPlus4     = PC + 32'd4;
    assign BranchTarget = PC + Immediate;
    assign JumpTarget   = PC + Immediate;


    // =========================================================
    // Instruction
    // =========================================================

    wire [31:0] Instruction;


    // =========================================================
    // Control signals
    // =========================================================

    wire RegWrite;
    wire ALUSrc;
    wire MemRead;
    wire MemWrite;
    wire MemToReg;
    wire Branch;
    wire Jump;

    wire [1:0] ALUOp;


    // =========================================================
    // Register File
    // =========================================================

    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    wire [31:0] WriteBackData;


    // =========================================================
    // Immediate Generator
    // =========================================================
    ImmediateGenerator Imm_Generator(
    .Instruction(Instruction),
    .Immediate(Immediate)
);

    // =========================================================
    // ALU
    // =========================================================

    wire [31:0] ALUInputB;
    wire [31:0] ALUResult;
    wire [3:0] ALUSel;
    wire Zero;


    // =========================================================
    // Data Memory
    // =========================================================

    wire [31:0] MemoryReadData;


    // =========================================================
    // PC
    // =========================================================

    ProgramCounter PC_Module(
        .clk(clk),
        .reset(reset),
        .PCNext(PCNext),
        .PC(PC)
    );


    // =========================================================
    // Instruction Memory
    // =========================================================

    InstructionMemory Instruction_Memory(
        .Address(PC),
        .Instruction(Instruction)
    );


    // =========================================================
    // Control Unit
    // =========================================================

    ControlUnit Control_Unit(
        .Opcode(Instruction[6:0]),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp)
    );


    // =========================================================
    // Register File
    // =========================================================

    RegisterFile Registers(
        .clk(clk),
        .RegWrite(RegWrite),
        .rs1(Instruction[19:15]),
        .rs2(Instruction[24:20]),
        .rd(Instruction[11:7]),
        .WriteData(WriteBackData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );


    // =========================================================
    // Immediate Generator
    // =========================================================


    // =========================================================
    // ALU Input MUX
    // ALUSrc = 0 → Register Data
    // ALUSrc = 1 → Immediate
    // =========================================================

    Mux2to1 ALU_MUX(
        .Input0(ReadData2),
        .Input1(Immediate),
        .Select(ALUSrc),
        .Output(ALUInputB)
    );


    // =========================================================
    // ALU Control
    // =========================================================

    ALUControl ALU_Control(
        .ALUOp(ALUOp),
        .funct3(Instruction[14:12]),
        .funct7(Instruction[30]),
        .ALUSel(ALUSel)
    );


    // =========================================================
    // ALU
    // =========================================================

    ALU ALU_Module(
        .A(ReadData1),
        .B(ALUInputB),
        .ALUSel(ALUSel),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );


    // =========================================================
    // Data Memory
    // =========================================================

    DataMemory Data_Memory(
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Address(ALUResult),
        .WriteData(ReadData2),
        .ReadData(MemoryReadData)
    );


    // =========================================================
    // Write Back
    // =========================================================

    // For normal instructions:
    // MemToReg = 0 → ALU Result
    // MemToReg = 1 → Memory Data

    wire [31:0] NormalWriteBack;

    Mux2to1 WriteBack_MUX(
        .Input0(ALUResult),
        .Input1(MemoryReadData),
        .Select(MemToReg),
        .Output(NormalWriteBack)
    );


    // JAL needs PC + 4 written into rd.
    assign WriteBackData = Jump ? PCPlus4 : NormalWriteBack;


    // =========================================================
    // Branch / Jump PC Logic
    // =========================================================

    wire TakeBranch;
    wire [1:0] PCSelect;
    assign TakeBranch = Branch & Zero;

    assign PCSelect = Jump ? 2'b10 :
                  TakeBranch ? 2'b01 :
                  2'b00;
    // PC selection:
    //
    // 00 → PC + 4
    // 01 → Branch Target
    // 10 → Jump Target

    Mux3to1 PC_MUX(
        .Input0(PCPlus4),
        .Input1(BranchTarget),
        .Input2(JumpTarget),
        .Select(
            Jump ? 2'b10 :
            TakeBranch ? 2'b01 :
            2'b00
        ),
        .Output(PCNext)
    );

endmodule