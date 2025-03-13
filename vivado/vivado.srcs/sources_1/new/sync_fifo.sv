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
    
    logic [$clog2(DEPTH):0] addr_diff;
    logic i_fifo_full, i_fifo_almost_full, i_fifo_empty, i_fifo_almost_empty;
    
    always_ff @(posedge clk)
    if (rst) begin
        addr_diff <= 0;
        wr_addr   <= 0;
        rd_addr   <= 0;
        dout      <= 0; // Needed?
    end else begin
        if (wr_en && ~i_fifo_full)
        begin
            fifo_data[wr_addr] <= din;
            wr_addr            <= wr_addr + 1;
        end
        if (rd_en && ~fifo_empty)
        begin
            dout    <= fifo_data[rd_addr];
            rd_addr <= rd_addr + 1;
        end
        
        if (wr_en && ~i_fifo_full && ~(rd_en && ~fifo_empty))
            addr_diff <= addr_diff + 1;
        else if (rd_en && ~fifo_empty && ~(wr_en && ~i_fifo_full))
            addr_diff <= addr_diff - 1;
    end
    
    always_comb begin
        i_fifo_full         = addr_diff == DEPTH;
        i_fifo_almost_full  = addr_diff == DEPTH - 1;
        i_fifo_empty        = addr_diff == 0;
        i_fifo_almost_empty = addr_diff == 1;
        
        fifo_full           = i_fifo_full;
        fifo_almost_full    = i_fifo_almost_full;
        fifo_empty          = i_fifo_empty;
        fifo_almost_empty   = i_fifo_almost_empty;
    end
    
endmodule
