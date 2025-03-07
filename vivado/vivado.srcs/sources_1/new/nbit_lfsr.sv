`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module nbit_lfsr
#(
    parameter
    depth = 8, // depth should be >= 2
    width = 4
)(
    input  logic             clk,
    input  logic             rst,
    output logic [width-1:0] sr_out
);

    logic [width-1:0] data_sr[0:depth-1];
    logic rst_sync1, rst_sync2;

    always_ff @(posedge clk or posedge rst)
    begin
        rst_sync1 <= rst;
        rst_sync2 <= rst_sync2;
        if (rst)
            for (int i = 0; i < depth; i++)
                if (i % 2 == 0)
                    data_sr[i] <= 0;
                else
                    data_sr[i] <= 1;
        else if (~rst_sync2)
            data_sr[0] <= data_sr[depth-1] ^ data_sr[depth-2];
    end

endmodule
