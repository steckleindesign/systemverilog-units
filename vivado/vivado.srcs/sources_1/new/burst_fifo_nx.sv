`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module burst_fifo_nx #(
    parameter string FASTER_CLK = "wr", // (wr, rd)
    parameter CLOCK_FREQ_RATIO  = 4,
    parameter WIDTH             = 8,
    parameter DEPTH             = 64
)(
    input  logic wr_clk, rd_clk,
    input  logic wr_en,  rd_en,
    input  logic [WIDTH-1:0] din,
    output logic [WIDTH-1:0] dout,
    output logic empty, full, almost_empty, almost_full
);

    logic fifo_empty, fifo_full, fifo_almost_empty, fifo_almost_full;

    // FIFO data with parameterizable width and depth
    logic [WIDTH-1:0] fifo_mem [0:DEPTH-1];
    
    // Cross clock domains with pointers gray encoded
    logic [$clog2(DEPTH)-1:0] wr_ptr_bin, rd_ptr_bin;
    logic [$clog2(DEPTH)-1:0] rd_ptr_gray, wr_ptr_gray;
    logic [$clog2(DEPTH)-1:0] rd_ptr_wrclk, rd_ptr_wrclk1, rd_ptr_wrclk2;
    logic [$clog2(DEPTH)-1:0] wr_ptr_rdclk, wr_ptr_rdclk1, wr_ptr_rdclk2;
    
    function automatic logic [$clog2(DEPTH)-1:0] bin2gray(input logic [$clog2(DEPTH)-1:0] bin);
        return bin ^ (bin >> 1);
    endfunction
    
    // Practice coding this in different ways
    function automatic logic [$clog2(DEPTH)-1:0] gray2bin(input logic [$clog2(DEPTH)-1:0] gray);
        logic [$clog2(DEPTH)-1:0] bin;
        for (int i = $clog2(DEPTH); i >= 0; i--)
            bin[i] = ^(gray >> i);
        return bin;
    endfunction
    
    always_ff @(wr_clk) begin
        rd_ptr_wrclk2 <= rd_ptr_gray;
        rd_ptr_wrclk1 <= rd_ptr_wrclk2;
        rd_ptr_wrclk  <= gray2bin(rd_ptr_wrclk1);
    end
    
    always_ff @(rd_clk) begin
        wr_ptr_rdclk2 <= wr_ptr_gray;
        wr_ptr_rdclk1 <= wr_ptr_rdclk2;
        wr_ptr_rdclk  <= gray2bin(wr_ptr_rdclk1);
    end
    
    always_ff @(rd_clk) begin
        fifo_empty        <=  rd_ptr_bin    == wr_ptr_rdclk;
        fifo_almost_empty <= (rd_ptr_bin+1) == wr_ptr_rdclk;
    end
    
    always_ff @(wr_clk) begin
        fifo_full        <=  wr_ptr_bin    == rd_ptr_wrclk;
        fifo_almost_full <= (wr_ptr_bin+1) == rd_ptr_wrclk;
    end
    
    generate
        case(FASTER_CLK)
            "wr": begin
                always_ff @(posedge wr_clk) begin
                    if (wr_en && ~fifo_full) begin
                        wr_ptr_bin++;
                        wr_ptr_gray <= bin2gray(wr_ptr_bin+1);
                        fifo_mem[wr_ptr_bin] <= din;
                    end
                end
                
                always_ff @(posedge rd_clk) begin
                    if (rd_en && ~fifo_empty) begin
                        rd_ptr_bin++;
                        rd_ptr_gray <= bin2gray(rd_ptr_bin+1);
                        dout <= fifo_mem[rd_ptr_bin];
                    end
                end
            end
            "rd": begin
                always_ff @(posedge wr_clk) begin
                    if (wr_en && ~fifo_full) begin
                        wr_ptr_bin++;
                        wr_ptr_gray <= bin2gray(wr_ptr_bin+1);
                        fifo_mem[wr_ptr_bin] <= din;
                    end
                end
                
                always_ff @(posedge rd_clk) begin
                    if (rd_en && ~fifo_empty) begin
                        rd_ptr_bin++;
                        rd_ptr_gray <= bin2gray(rd_ptr_bin+1);
                        dout <= fifo_mem[rd_ptr_bin];
                    end
                end
            end
            // wr clk is same frequency as read clock
            default: begin
                always_ff @(posedge wr_clk) begin
                    if (wr_en && ~fifo_full) begin
                        wr_ptr_bin++;
                        wr_ptr_gray <= bin2gray(wr_ptr_bin+1);
                        fifo_mem[wr_ptr_bin] <= din;
                    end
                end
                
                always_ff @(posedge rd_clk) begin
                    if (rd_en && ~fifo_empty) begin
                        rd_ptr_bin++;
                        rd_ptr_gray <= bin2gray(rd_ptr_bin+1);
                        dout <= fifo_mem[rd_ptr_bin];
                    end
                end
            end
        endcase
    endgenerate

endmodule