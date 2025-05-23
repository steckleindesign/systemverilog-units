`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module nbit_reversal
#(
    parameter N = 16
)(
    input  logic [N-1:0] data,
    output logic [N-1:0] reversed
);

    assign reversed = {<<{data}};

endmodule
