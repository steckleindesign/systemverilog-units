`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module nbyte_reversal
#(
    parameter N = 4
)(
    input  logic [7:0] data[0:N-1],
    output logic [7:0] reversed[0:N-1]
);

    assign reversed = {>>{data}};

endmodule
