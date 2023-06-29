/* Grupo 15
Aluno: Pedro Freitas Fassini, NUSP: 12566571
Aluno: Antônio Freitas Fassini, NUSP:12551032 
Aluno: Gustavo Scardino, NUSP: 11797229
Arquivo: Código do Registrador Parametrizável*/



module registrador #(parameter N=8) 
(
    input [N-1:0] D,
    input load,
    input clk,
    output  reg signed [N-1:0] Q
);
    


always @(posedge clk ) begin
    
    if (load) Q <= D;
end



endmodule