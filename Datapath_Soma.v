module Datapath_Soma #(
    parameter N_float = 32,
    parameter N_exp= 8,
    parameter N_mant=23,
    parameter N_mant_maisum =24,
    parameter N_mant_maisdois =25
) (
    input [N_float -1:0] float_A,
    input [N_float -1:0] float_B,
    output [N_float -1:0] float_R,
    input [1:0] sel_mux_normalizer,
    input [1:0] sel_normalizer, //sinais de controle da UC 
    input sinal_01,
    // sinais de controle para UC 
    output check_normalizer_round,
    output [1:0] antes_virgula
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
wire [N_exp-1:0] diferenca_exp;

sum_sub  #(N_exp)SmallAlu (
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
wire [N_mant:0] Alu_BGE_in_left;
wire [N_mant:0] Alu_BGE_in_right;

assign Shift_Dif_in = (diferenca_exp[N_exp-1])?mant_A_imp:mant_B_imp; 
assign Alu_BGE_in_right = (diferenca_exp[N_exp-1])?mant_B_imp:mant_A_imp;   


ShiftModule #(.N_mant(N_mant_maisum), .N_exp(N_exp)) Shift_Dif (.data_in(Shift_Dif_in), .shifted_data(Alu_BGE_in_left), .shift_amout(shift_amout_un));

wire sinal_bge_in_left;
assign sinal_bge_in_left = (diferenca_exp[N_exp-1])?sig_A:sig_B;
wire sinal_bge_in_right;
assign sinal_bge_in_right = (diferenca_exp[N_exp-1])?sig_B:sig_A; 

//instanciacao alu bge
wire [N_mant:0] maior_mantissa;
wire [N_mant:0] menor_mantissa;
wire sinal_resultado;

Alu_BGE  #(N_mant_maisum) Alu_BGE_DP (
  .left(Alu_BGE_in_left),
  .sinal_left(sinal_bge_in_left),
  .right(Alu_BGE_in_right),
  .sinal_right(sinal_bge_in_right),
  .maior_mantissa(maior_mantissa),
  .menor_mantissa(menor_mantissa),
  .sinal_resultado(sinal_resultado),
  .Cout()
);


//Instanciação da Big Alu

wire [N_mant:0] result_BigAlu_intermediario;
wire [N_mant+1:0] result_BigAlu;
wire Cout;
sum_sub #(N_mant_maisum) BigAlu (
.A(maior_mantissa),
.B(menor_mantissa),
.subtract(sig_A^sig_B),
.result(result_BigAlu_intermediario),
.Cout(Cout)
);

assign result_BigAlu = {Cout,result_BigAlu_intermediario};

//Determinando expoente até o momento (igual para o float A e B)

wire [N_exp-1:0] exp_resultado;

assign exp_resultado = (diferenca_exp[N_exp-1])? exp_B: exp_A;

//Preparação instanciação Normalizer Hardware

wire [N_mant+1:0] mant_normalizer_in;
wire [N_exp-1:0] exp_normalizer_in;

assign antes_virgula = mant_normalizer_in [N_mant+1:N_mant]; 

wire [N_mant:0] mant_normalizer_out;
wire [N_exp-1:0] exp_normalizer_out;
wire mantissa_lsb;

wire [N_mant:0] mant_round;
wire [N_exp-1:0] exp_round;

//mux triplo
assign mant_normalizer_in = (sel_mux_normalizer==00)? result_BigAlu:
                         (sel_mux_normalizer== 01)? {mant_normalizer_out, mantissa_lsb}:
                         (sel_mux_normalizer ==10)? mant_round:result_BigAlu;

assign exp_normalizer_in = (sel_mux_normalizer==00)? exp_resultado:
                         (sel_mux_normalizer== 01)? exp_normalizer_out:
                         (sel_mux_normalizer ==10)? exp_round:exp_resultado;

//Instanciação do Normalizer

Normalizer  #(.N_mant(N_mant_maisdois),
    .N_exp(N_exp)) Normalizer_DP (
        .mantissa_in(mant_normalizer_in),
        .expoente_in(exp_normalizer_in),
        .sel(sel_normalizer),
        .mantissa_out(mant_normalizer_out),
        .expoente_out(exp_normalizer_out),
        .mantissa_lsb(mantissa_lsb)
        );

//Instanciação do Round

assign exp_round = exp_normalizer_out;

wire [63:0] arredondador;

assign arredondador = {63'b0,mantissa_lsb};

sum_sub #(N_mant_maisum) RoundHardware (
    .A(mant_normalizer_out),
    .B(arredondador[N_mant:0]),
    .subtract(1'b0),
    .result(mant_round),
    .Cout(check_normalizer_round)
    );

//Finalizando

assign float_R = (~sinal_01)?{sinal_resultado, exp_round, mant_round[N_mant-1:0]}:
                    {sinal_resultado,exp_normalizer_in,mant_normalizer_in[N_mant-3:0]};

endmodule