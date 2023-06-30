module Datapath-Soma #(
    N_float = 32,
    N_exp= 8,
    N_mant=23
) (
    input [N_float -1:0] float_A,
    input [N_float -1:0] float_B,
    output [N_float -1:0] float_R,
    input  BigAlu_in_A, BigAlu_in_B, ShiftDif_amount, Exp_sel, ShiftNorm_sel, ShiftNorm_amount, Increment_sel, Increment_amount, Roud_amount, //sinais de controle da UC 
    // sinais de controle para UC 
    output [N_exp-1:0] diferenca_exp 
);


//separação do expoente

wire [N_exp-1:0] exp_A;
wire [N_exp-1:0] exp_B;

assign exp_A = float_A[N_float-2:N_float-N_exp-1];
assign exp_B = float_B[N_float-2:N_float-N_exp-1];

//separação da mantissa

wire [N_mant-1:0] mant_A;
wire [N_mant-1:0] mant_B;

assign mant_A= float_A[N_float-N_exp-2:0];
assign mant_B= float_B[N_float-N_exp-2:0];

//Expansão para o Implicito 1

wire [N_mant:0] mant_A_imp;
wire [N_mant:0] mant_B_imp;

assign mant_A_imp ={1'b1, mant_A};
assign mant_B_imp ={1'b1, mant_B};

//separação do sinal

wire sig_A;
wire sig_B;

assign sig_A= float_A[N_float-1];
assign sig_B= float_B[N_float-1];

//Instanciação Small Alu

sum_sub SmallAlu #(N_exp)(
    .A(exp_A),
    .B(exp_B),
    .subtract(1'b1),
    .result(diferenca_exp),
    .Cout()
);

//Instanciação do primeiro Shifter (relacionado à diferença de expoentes)

wire [N_exp-1:0] shift_amout_un;
assign shift_amout_un = (diferenca_exp[N_exp-1])? (~diferenca_exp+1):diferenca_exp; //revertendo o complemento de dois

//Muxes da entrada do primeiro Shifter

wire [N_mant:0] Shift_Dif_in;
wire [N_mant:0] BigAlu_in_left;
wire [N_mant:0] BigAlu_in_right;

assign Shift_Dif_in = (diferenca_exp[N_exp-1])?mant_A_imp:mant_B_imp; 
assign BigAlu_in_right = (diferenca_exp[N_exp-1])?mant_B_imp:mant_A_imp;   


ShiftModule #(DATA_WIDTH=N_mant+1, SHIFT_AMOUNT= , 1) Shift_Dif (.data_in(Shift_Dif_in), .shifted_data(BigAlu_in_left));

//Instanciação da Big Alu

sum_sub #(N_mant+1) BigAlu (
.A(BigAlu_in_left)
.B(BigAlu_in_right)
.subtract()
.result()
.Cout()

);







endmodule