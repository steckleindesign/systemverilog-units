`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module nbit_parallel_mux
#(
    parameter
    N     = 4, // # of inputs
    WIDTH = 16 // input data bit width
)(
    input  logic [WIDTH-1:0]     data_in[0:N-1],
    input  logic [$clog2(N)-1:0] sel,
    output logic [WIDTH-1:0]     data_out
);

    always_comb
        data_out = data_in[sel];

endmodule
