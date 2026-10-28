module Mux2to1(
    input  [31:0] Input0,
    input  [31:0] Input1,
    input         Select,
    output [31:0] Output
);

assign Output = Select ? Input1 : Input0;

endmodule