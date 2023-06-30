
module Normaliser
 #(
    N_mant =25;
    N_exp = 8;
) (
    input [N_mant-1:0] mantissa_in,
    input [N_exp-1:0] expoente_in,
    input sel,                                 //0: shift left 1x and decrement exponent 1
                                               //1: shift right 1x and increment exponent 0 
    output [N_mant-2:0] mantissa_out, 
    output mantissa_lsb,
    output [N_exp-1:0] expoente_out 
);
    
assign mantissa_lsb = (sel)?mantissa_in[0]:1'b0;
assign mantissa_out = (sel)? mantissa_in[N_mant-1:1]:[N_mant:0];
assign exp_out = (sel)? exp_in+1:exp_in-1;


endmodule