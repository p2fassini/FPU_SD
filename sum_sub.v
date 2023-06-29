module sum_sub #(
  parameter WIDTH = 64
)(
  input [WIDTH-1:0] A,
  input [WIDTH-1:0] B,
  input subtract,
  output [WIDTH-1:0] result,
  output Cout
); 

  wire [WIDTH:0] C;
  assign C[0] = subtract;

  wire B_alterado;


  genvar i;
  generate
    for (i = 0; i < WIDTH; i = i + 1) begin : fa_inst
      fullAdder FA (
        .A(A[i]),
        .B(B[i] ^ subtract),
        .Cin(C[i]),
        .result(result[i]),
        .Cout(C[i+1])
      );
    end
  endgenerate

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