`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////

module nbit_barrel_shifter
#(
    parameter data_width = 16
)(
    input  logic [data_width-1:0]         data,
    input  logic [$clog2(data_width)-1:0] amt,
    output logic [data_width-1:0]         shifted_data
);

    localparam num_stages = $clog2(data_width);
    
    logic [num_stages-1:0][data_width-1:0] stages;
    
    generate
        genvar i;
        assign stages[0] = amt[0] ? {data[0], data[data_width-1:1]} : data;
        for (i = 1; i < num_stages; i++)
        begin
            assign stages[i] =
                amt[i] ? {stages[i-1][i**2:0], stages[i-1][data_width-1:2**i]}
                       : stages[i-1];
        end
        assign shifted_data = stages[num_stages-1];
    endgenerate

endmodule
