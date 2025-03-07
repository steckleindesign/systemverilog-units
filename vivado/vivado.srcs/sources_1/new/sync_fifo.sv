`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module sync_fifo
#(
    parameter
    WIDTH = 8,
    DEPTH = 128
)(
    input  logic             clk,
    input  logic             rst,
    input  logic             wr_en,
    input  logic             rd_en,
    input  logic [WIDTH-1:0] din,
    output logic [WIDTH-1:0] dout,
    output logic             fifo_full,
    output logic             fifo_almost_full,
    output logic             fifo_empty,
    output logic             fifo_almost_empty
);

    logic [WIDTH-1:0] fifo_data[0:DEPTH-1];
    logic [$clog2(DEPTH)-1:0] wr_addr, rd_addr;
    
    logic addr_diff;
    
    always_ff @(posedge clk)
    if (rst) begin
        addr_diff <= 0;
        wr_addr   <= 0;
        rd_addr   <= 0;
    end else begin
        if (wr_en)
        begin
            fifo_data[wr_addr] <= din;
            wr_addr            <= wr_addr + 1;
            addr_diff          <= addr_diff + 1;
        end
        if (rd_en)
        begin
            rd_addr   <= rd_addr + 1;
            addr_diff <= addr_diff - 1;
        end
    end
    
    assign dout = fifo_data[rd_addr];
    
    assign fifo_full         = addr_diff == DEPTH;
    assign fifo_almost_full  = addr_diff == DEPTH - 1;
    assign fifo_empty        = addr_diff == 0;
    assign fifo_almost_empty = addr_diff == 1;

endmodule
