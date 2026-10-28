`timescale 1ns/1ps

module CPU_Testbench;

    reg clk;
    reg reset;

    // Instantiate CPU
    CPU uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        // Initialize
        clk = 1'b0;
        reset = 1'b1;

        // Hold reset for 10 ns
        #10;
        reset = 1'b0;

        // Run processor
        #100;

        // Display register values
        $display("--------------------------------");
        $display("RISC-V CPU TEST");
        $display("--------------------------------");

        $display("x1 = %d", uut.Registers.Registers[1]);
        $display("x2 = %d", uut.Registers.Registers[2]);
        $display("x3 = %d", uut.Registers.Registers[3]);

        $display("--------------------------------");

        // Check results
        if (uut.Registers.Registers[1] == 32'd10)
            $display("PASS: x1 = 10");
        else
            $display("FAIL: x1 is incorrect");

        if (uut.Registers.Registers[2] == 32'd20)
            $display("PASS: x2 = 20");
        else
            $display("FAIL: x2 is incorrect");

        if (uut.Registers.Registers[3] == 32'd30)
            $display("PASS: x3 = 30");
        else
            $display("FAIL: x3 is incorrect");

        $display("--------------------------------");

        $finish;
    end

endmodule
