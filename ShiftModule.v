module ShiftModule #(parameter DATA_WIDTH = 32, parameter SHIFT_AMOUNT = 1, parameter SHIFT_DIRECTION = 0) (
  input wire [DATA_WIDTH-1:0] data_in,
  output wire [DATA_WIDTH-1:0] shifted_data
);

  wire [DATA_WIDTH-1:0] shifted_left;
  wire [DATA_WIDTH-1:0] shifted_right;

  assign shifted_left = data_in << SHIFT_AMOUNT;
  assign shifted_right = data_in >> SHIFT_AMOUNT;

  assign shifted_data = (SHIFT_DIRECTION == 0) ? shifted_left : shifted_right;

endmodule
