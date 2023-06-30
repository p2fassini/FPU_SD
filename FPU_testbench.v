module FPU_testbench;
  
  reg clk, rst, start;
  reg [31:0] A, B;
  wire [31:0] R;
  wire done;
  reg [1:0] op;
  
  fpu dut (
    .clk(clk),
    .rst(rst),
    .A(A),
    .B(B),
    .R(R),
    .op(op),
    .start(start),
    .done(done)
  );
  
  always #5 clk = ~clk; // Gerador de clock
  
  initial begin
    clk = 0;
    rst = 1;
    start = 0;
    op = 2'b00; // Define a operação de soma
    
    #10; // Aguarda um pouco após a inicialização
    
    // Teste 1: Soma
    A = {1'b0,8'b00000011 ,23'b00001000000000000000100 };
    B = {1'b0,8'b00000001 ,23'b00011000000010000001100 };
    start = 1;
    #20;
    start = 0;
    #100;

    //assert (R == {1'b0, 8'b00000011, 23'b01001110000000100000111});

    
    // // Teste 2: Subtração
    // A = {1'b0,8'b00000001 ,23'b00000000000000000000000 };
    // B = {1'b0,8'b00000001 ,23'b00000000000000000000000 };
    // op = 2'b01; // Define a operação de subtração
    // start = 1;
    // #20;
    // start = 0;
    // #100;
    
    // // Teste 3: Multiplicação
    // A = {1'b0,8'b00000001 ,23'b00000000000000000000000 };
    // B = {1'b0,8'b00000001 ,23'b00000000000000000000000 };
    // op = 2'b10; // Define a operação de multiplicação
    // start = 1;
    // #20;
    // start = 0;
    // #100;
    
    // // Teste 4: Divisão
    // A = {1'b0,8'b00000001 ,23'b00000000000000000000000 };
    // B = {1'b0,8'b00000001 ,23'b00000000000000000000000 };
    // op = 2'b11; // Define a operação de divisão
    // start = 1;
    // #20;
    // start = 0;
    // #100;
    
    $finish; // Encerra a simulação
  end
  
endmodule
