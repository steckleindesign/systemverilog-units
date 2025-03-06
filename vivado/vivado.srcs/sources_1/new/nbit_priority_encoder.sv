`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module nbit_priority_encoder
#(
    parameter N = 4 // priorities
)(
    input  logic [N-1:0]         flag,
    output logic [$clog2(N)-1:0] highest_priority
);

    always_comb
        for (int i = 0; i < N; i++)
            if (flag[i])
                highest_priority = i;
    
endmodule
