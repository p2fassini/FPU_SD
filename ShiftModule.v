module ShiftModule #(parameter N_mant = 24, parameter N_exp = 8, parameter SHIFT_DIRECTION = 0) (
  input wire [N_mant-1:0] data_in,
  input [N_exp-1:0] shift_amout,
  output [N_mant-1:0] shifted_data
);

  wire [N_mant-1:0] shifted_left;
  wire [N_mant-1:0] shifted_right;

  assign shifted_left = data_in << shift_amout;
  assign shifted_right = data_in >> shift_amout;

  assign shifted_data = (SHIFT_DIRECTION == 0) ? shifted_left : shifted_right;

endmodule
