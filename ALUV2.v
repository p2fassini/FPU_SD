module ALU #(
    parameter N=64
) (
    input [N-1:0] A,
    input [N-1:0] B,
    input [1:0] sel_alu,
    output [N-1:0] result,
    output flag_beq,
    output flag_bnq,
    output flag_blt,
    output flag_bge,
    output flag_bltu,
    output flag_zero,
    output flag_msb,
    output flag_over
);

//Sinais intermediários

wire mux_subtract;
wire [N-1:0] result_sum;
wire [N-1:0] result_and;
wire [N-1:0] result_or;
wire [N-1:0] aux_beq;
wire [N-1:0] aux_blt;


assign mux_subtract = (sel_alu==01)? 1:0;


//Instanciação do Somador

sum_sub #(N) somador_alu
(
.A (A),
.B(B),
.subtract (mux_subtract),
.result (result_sum),
.Cout ()
);

//Determinação result_and and result_or

assign result_and= A & B;

assign result_or = A | B;



assign result = (sel_alu[1:0]==2'b00)? result_sum: 
                (sel_alu[1:0]==2'b01)? result_sum:
                (sel_alu[1:0]==2'b10)? result_and:
                (sel_alu[1:0] ==2'b11)? result_or: result_sum;


//Determinando as flags



genvar i;

//flag beq

assign aux_beq = A ~^ B;

assign flag_beq = & aux_beq;

//flag bnq

assign flag_bnq = ~ flag_beq;

//flag blt e bge

somadorSubtrator #(N) somador_flag
(
.A (A),
.B(B),
.subtract (1'b1),
.result (aux_blt),
.Cout ()
);

assign flag_blt = aux_blt[N-1];

assign flag_bge = ~aux_blt[N-1];

//flag zero

assign flag_zero = ~&result;

// flag_msb

assign flag_msb = result[63];

// flag_over

assign flag_over = 1'b0;





endmodule