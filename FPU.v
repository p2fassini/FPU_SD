module fpu (
    input  clk, 
    input  rst,   // reset assíncrono
    input  [31:0] A,
    input  [31:0] B, // Entradas
    output [31:0] R,   // Saída
    input  [1:0] op,   // 00:soma, 01:subtração, 10:multiplicação, 11:divisão
    input  start,      // 1: começa o cálculo, done vai pra zero
    output done       // 1: cálculo terminado, fica em 1 até start ir de zero para um
);

wire [1:0] sel_mux_normalizer_int;
wire [1:0] antes_virgula_int;
wire sel_normalizer_int;
wire check_normalizer_round_int;
wire sinal_01_int;

Datapath_Soma Datapath_Soma_FPU(
    .float_A(A),
    .float_B(B),
    .float_R(R),
    .sel_mux_normalizer(sel_mux_normalizer_int),
    .sel_normalizer(sel_normalizer_int), //sinais de controle da UC 
    // sinais de controle para UC 
    .check_normalizer_round(check_normalizer_round_int),
    .antes_virgula(antes_virgula_int),
    .sinal_01(sinal_01_int)
);

UC UC_FPU(
    .clk(clk), 
    .start(start), 
    .reset(rst),
    .antes_virgula(antes_virgula_int),
    .check_normalizer_round(check_normalizer_round_int),
    .sel_mux_normalizer(sel_mux_normalizer_int),
    .sel_normalizer(sel_normalizer_int),
    .done(done),
    .sinal_01(sinal_01_int)
);


endmodule