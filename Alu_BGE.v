module Alu_BGE #(
  parameter WIDTH = 24
)(
  input [WIDTH-1:0] left,
  input sinal_left,
  input [WIDTH-1:0] right,
  input sinal_right,
  output [WIDTH-1:0] maior_mantissa,
  output [WIDTH-1:0] menor_mantissa,
  output sinal_resultado,
  output Cout
); 
  wire subtract;
  assign subtract = 1'b1;
  wire [WIDTH:0] C;
  wire [WIDTH-1:0] result;

  genvar i;
  generate
    for (i = 0; i < WIDTH; i = i + 1) begin : fa_inst
      fullAdder FA (
        .A(left[i]),
        .B(right[i] ^ subtract),
        .Cin(C[i]),
        .result(result[i]),
        .Cout(C[i+1])
      );
    end
  endgenerate

  assign maior_mantissa = (result[WIDTH-1])?right:left;
  assign menor_mantissa = (result[WIDTH-1])?left:right;
  assign sinal_resultado =(result[WIDTH-1])?sinal_right:sinal_left;

  assign Cout = C[WIDTH];

endmodule



module fullAdder (
    input A,
    input B,
    input Cin,
    output result,
    output Cout
);

    assign result = A ^ B ^ Cin;
    assign Cout = (A & B) | (Cin & (A | B));
    
endmodule