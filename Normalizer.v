
module Normalizer
 #(
    parameter N_mant =25,
    parameter N_exp = 8
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
assign mantissa_out = (sel)? mantissa_in[N_mant-1:1]:mantissa_in[N_mant:0];
assign expoente_out = (sel)? expoente_in+1:expoente_in-1;


endmodule