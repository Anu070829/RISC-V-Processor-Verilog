module Mux3to1(
    input  [31:0] Input0,
    input  [31:0] Input1,
    input  [31:0] Input2,
    input  [1:0]  Select,
    output reg [31:0] Output
);

always @(*) begin

    case (Select)

        2'b00:
            Output = Input0;

        2'b01:
            Output = Input1;

        2'b10:
            Output = Input2;

        default:
            Output = 32'b0;

    endcase

end

endmodule
