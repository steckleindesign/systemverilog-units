`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module async_fifo #(
    parameter int WIDTH = 8,
    parameter int DEPTH = 16
)(
    input  logic              wr_clk,
    input  logic              rd_clk,
    input  logic              wr_rst,
    input  logic              rd_rst,
    input  logic              wr_en,
    input  logic              rd_en,
    input  logic [WIDTH-1:0]  din,
    output logic [WIDTH-1:0]  dout,
    output logic              full,
    output logic              empty
);

    localparam int ADDR_WIDTH = $clog2(DEPTH);

    logic [WIDTH-1:0] fifo_mem [DEPTH-1:0];

    logic [ADDR_WIDTH:0] wr_ptr_bin, wr_ptr_gray, wr_ptr_gray_rdclk;
    logic [ADDR_WIDTH:0] rd_ptr_bin, rd_ptr_gray, rd_ptr_gray_wrclk;

    logic [ADDR_WIDTH:0] wr_ptr_gray_rdclk_sync1, wr_ptr_gray_rdclk_sync2;
    logic [ADDR_WIDTH:0] rd_ptr_gray_wrclk_sync1, rd_ptr_gray_wrclk_sync2;

    function automatic logic [ADDR_WIDTH:0] bin2gray(input logic [ADDR_WIDTH:0] bin);
        return bin ^ (bin >> 1);
    endfunction

    function automatic logic [ADDR_WIDTH:0] gray2bin(input logic [ADDR_WIDTH:0] gray);
        logic [ADDR_WIDTH:0] bin;
        for (int i = ADDR_WIDTH; i >= 0; i--)
            bin[i] = ^(gray >> i);
        return bin;
    endfunction

    always_ff @(posedge wr_clk or posedge wr_rst) begin
        if (wr_rst) begin
            wr_ptr_bin  <= 0;
            wr_ptr_gray <= 0;
        end else if (wr_en && !full) begin
            fifo_mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= din;
            wr_ptr_bin  <= wr_ptr_bin + 1;
            wr_ptr_gray <= bin2gray(wr_ptr_bin + 1);
        end
    end

    always_ff @(posedge rd_clk or posedge rd_rst) begin
        if (rd_rst) begin
            rd_ptr_bin  <= 0;
            rd_ptr_gray <= 0;
            dout <= '0;
        end else if (rd_en && !empty) begin
            dout <= fifo_mem[rd_ptr_bin[ADDR_WIDTH-1:0]];
            rd_ptr_bin  <= rd_ptr_bin + 1;
            rd_ptr_gray <= bin2gray(rd_ptr_bin + 1);
        end
    end

    always_ff @(posedge rd_clk or posedge rd_rst) begin
        if (rd_rst) begin
            wr_ptr_gray_rdclk_sync1 <= 0;
            wr_ptr_gray_rdclk_sync2 <= 0;
        end else begin
            wr_ptr_gray_rdclk_sync1 <= wr_ptr_gray;
            wr_ptr_gray_rdclk_sync2 <= wr_ptr_gray_rdclk_sync1;
        end
    end

    always_ff @(posedge wr_clk or posedge wr_rst) begin
        if (wr_rst) begin
            rd_ptr_gray_wrclk_sync1 <= 0;
            rd_ptr_gray_wrclk_sync2 <= 0;
        end else begin
            rd_ptr_gray_wrclk_sync1 <= rd_ptr_gray;
            rd_ptr_gray_wrclk_sync2 <= rd_ptr_gray_wrclk_sync1;
        end
    end

    assign wr_ptr_gray_rdclk = gray2bin(wr_ptr_gray_rdclk_sync2);
    assign rd_ptr_gray_wrclk = gray2bin(rd_ptr_gray_wrclk_sync2);

    assign empty = (rd_ptr_gray == wr_ptr_gray_rdclk);
    assign full  = (wr_ptr_gray == {~rd_ptr_gray_wrclk[ADDR_WIDTH:ADDR_WIDTH-1], rd_ptr_gray_wrclk[ADDR_WIDTH-2:0]});

endmodule
