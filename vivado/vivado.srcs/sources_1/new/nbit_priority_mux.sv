`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////


module nbit_priority_mux
#(
    parameter
    num_inputs = 2,
    data_width = 8
)(
    input  logic [data_width-1:0]         din[0:num_inputs-1],
    input  logic [$clog2(num_inputs)-1:0] sel,
    output logic [data_width-1:0]         dout
);

    localparam DEFAULT_DOUT = 1'b0;

    always_comb
    begin
        dout = DEFAULT_DOUT;
        for (int i = 0; i < num_inputs; i++)
        begin
            if (sel[i])
            begin
                dout = din[i];
                break;
            end
        end
    end
    
endmodule
