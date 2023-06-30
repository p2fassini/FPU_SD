module UC #(
    input clk, start, reset,
    input [1:0] antes_virgula,
    input check_normalizer_round,
    output [1:0] sel_mux_normalizer,
    output [1:0] sel_normalizer,
    output done
);
    
      // Definição dos estados
  parameter INITIAL           = 4'b0000;
  parameter SUM               = 4'b0001;
  parameter NORMALIZER        = 4'b0010;
  parameter ROUND             = 4'b0011;
  parameter DONE              = 4'b0100;
  
  // Declaração dos registradores
  reg [3:0] estado_atual;
  reg [3:0] proximo_estado;

   // Atribuição do estado inicial
  initial estado_atual = FETCH;

    //Definição da máquina de estados
    always @(posedge clk) begin
        case (estado_atual)
    
    INITIAL: 
        if(start)
            proximo_estado = SUM;
        else 
            proximo_estado= INITIAL;

    SUM:
        proximo_estado= NORMALIZER;

    NORMALIZER:
    if (antes_virgula[1]==1)
        proximo_estado= NORMALIZER;
    else if(antes_virgula[0]==1)
        proximo_estado= ROUND;
    else proximo_estado = NORMALIZER;

    ROUND:
    if(check_normalizer_round==1)
        proximo_estado = NORMALIZER;
    else 
        proximo_estado = DONE;
    DONE:
        if(reset)
            proximo_estado =INITIAL;
        else   
            proximo_estado =DONE;

        endcase
    end

assign sel_normalizer = (estado_atual == NORMALIZER & antes_virgula==00)? 0:1;

assign sel_mux_normalizer = (estado_atual == SUM)? 00:
                            (estado_atual == NORMALIZER)? 01:
                            (estado_atual == ROUND)? 10: 00;

assign done = (estado_atual==DONE)?1:0;



endmodule