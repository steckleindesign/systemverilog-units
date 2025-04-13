`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

import clk_spec_param_pkg ::*;

module burst_fifo_nx #(
    parameter clk_spec_t FASTER_CLK = WR, // (WR,RD)
    parameter CLOCK_FREQ_RATIO      = 4,
    parameter WIDTH                 = 8,
    parameter DEPTH                 = 64
)(
    input  logic wr_clk, rd_clk,
    input  logic wr_en,  rd_en,
    input  logic [$clog2(DEPTH)-1:0] burst_size,
    input  logic [WIDTH-1:0] din,
    output logic [WIDTH-1:0] dout,
    output logic empty, full, almost_empty, almost_full
);

    logic fifo_empty, fifo_full, fifo_almost_empty, fifo_almost_full;

    // FIFO data with parameterizable width and depth
    logic [WIDTH-1:0] fifo_mem [0:DEPTH-1];
    
    // Cross clock domains with pointers gray encoded
    logic [$clog2(DEPTH):0] wr_ptr_bin, rd_ptr_bin;
    logic [$clog2(DEPTH):0] rd_ptr_gray, wr_ptr_gray;
    logic [$clog2(DEPTH):0] rd_ptr_wrclk, rd_ptr_wrclk1, rd_ptr_wrclk2;
    logic [$clog2(DEPTH):0] wr_ptr_rdclk, wr_ptr_rdclk1, wr_ptr_rdclk2;
    
    function automatic logic [$clog2(DEPTH):0] bin2gray(input logic [$clog2(DEPTH):0] bin);
        return bin ^ (bin >> 1);
    endfunction
    
    // Practice coding this in different ways
    function automatic logic [$clog2(DEPTH):0] gray2bin(input logic [$clog2(DEPTH):0] gray);
        logic [$clog2(DEPTH):0] bin;
        for (int i = $clog2(DEPTH); i >= 0; i--)
            bin[i] = ^(gray >> i);
        return bin;
    endfunction
    
    always_ff @(rd_clk) begin
        fifo_empty        <=  rd_ptr_bin    == wr_ptr_rdclk;
        fifo_almost_empty <= (rd_ptr_bin+1) == wr_ptr_rdclk;
    end
    
    always_ff @(wr_clk) begin
        fifo_full        <=  wr_ptr_bin    == {~rd_ptr_wrclk[$clog2(DEPTH)], rd_ptr_wrclk[$clog2(DEPTH)-1:0]};
        fifo_almost_full <= (wr_ptr_bin+1) == {~rd_ptr_wrclk[$clog2(DEPTH)], rd_ptr_wrclk[$clog2(DEPTH)-1:0]};
    end
    
    generate
        case(FASTER_CLK)
            WR: begin
            
                // Max depth calculation
                // Say we write at 100MHz and read at 10MHz
                // Say burst size is 100
                // Time required for 1 write is 10ns
                // Time required for burst write is 1000ns = 1us
                // Time required for read is 100ns
                // Data read during burst write is 10 words
                // Buffer size is burst size minus data read during burst
                // = 100 - 10 = 90
                // Minimum burst to burst gap is 90 * 100ns = 9000ns = 9us
                // (can either read during burst writing, or start burst
                //  write when there are only 10 words left to read)
                
            
                always_ff @(posedge wr_clk) begin
                    if (wr_en && ~fifo_full) begin
                        wr_ptr_bin  <= wr_ptr_bin + 1;
                        wr_ptr_gray <= bin2gray(wr_ptr_bin+1);
                        fifo_mem[wr_ptr_bin[$clog2(DEPTH)-1:0]] <= din;
                    end
                end
                
                always_ff @(posedge rd_clk) begin
                    if (rd_en && ~fifo_empty) begin
                        rd_ptr_bin  <= rd_ptr_bin + 1;;
                        rd_ptr_gray <= bin2gray(rd_ptr_bin+1);
                        dout        <= fifo_mem[rd_ptr_bin[$clog2(DEPTH)-1:0]];
                    end
                end
                
                always_ff @(wr_clk) begin
                    rd_ptr_wrclk2 <= rd_ptr_gray;
                    rd_ptr_wrclk1 <= rd_ptr_wrclk2;
                    rd_ptr_wrclk  <= gray2bin(rd_ptr_wrclk1);
                end
                
                // toggle, handshake, pulse extender
                always_ff @(rd_clk) begin
                    wr_ptr_rdclk2 <= wr_ptr_gray;
                    wr_ptr_rdclk1 <= wr_ptr_rdclk2;
                    wr_ptr_rdclk  <= gray2bin(wr_ptr_rdclk1);
                end
            end
            RD: begin
                always_ff @(posedge wr_clk) begin
                    if (wr_en && ~fifo_full) begin
                        wr_ptr_bin  <= wr_ptr_bin + 1;
                        wr_ptr_gray <= bin2gray(wr_ptr_bin+1);
                        fifo_mem[wr_ptr_bin[$clog2(DEPTH)-1:0]] <= din;
                    end
                end
                
                always_ff @(posedge rd_clk) begin
                    if (rd_en && ~fifo_empty) begin
                        rd_ptr_bin  <= rd_ptr_bin + 1;
                        rd_ptr_gray <= bin2gray(rd_ptr_bin+1);
                        dout        <= fifo_mem[rd_ptr_bin[$clog2(DEPTH)-1:0]];
                    end
                end
                
                // toggle, handshake, pulse extender
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
            end
            // wr clk is same frequency as read clock
            default: begin
                always_ff @(posedge wr_clk) begin
                    if (wr_en && ~fifo_full) begin
                        wr_ptr_bin  <= wr_ptr_bin + 1;
                        wr_ptr_gray <= bin2gray(wr_ptr_bin+1);
                        fifo_mem[wr_ptr_bin[$clog2(DEPTH)-1:0]] <= din;
                    end
                end
                
                always_ff @(posedge rd_clk) begin
                    if (rd_en && ~fifo_empty) begin
                        rd_ptr_bin  <= rd_ptr_bin + 1;
                        rd_ptr_gray <= bin2gray(rd_ptr_bin+1);
                        dout        <= fifo_mem[rd_ptr_bin[$clog2(DEPTH)-1:0]];
                    end
                end
                
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
            end
        endcase
    endgenerate
    
    assign empty        = fifo_empty;
    assign full         = fifo_full;
    assign almost_empty = fifo_almost_empty;
    assign almost_full  = fifo_almost_full;

endmodule