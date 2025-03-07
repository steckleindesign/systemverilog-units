`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module nbit_comparator
#(
    parameter
    int N           = 8,
    bit SIGNED_MODE = 0 // 0 = Unsigned, 1 = Signed
)(
    input  logic [N-1:0] A,
    input  logic [N-1:0] B,
    output logic eq,
    output logic lt,
    output logic gt
);

    generate
        if (SIGNED_MODE) begin : signed_comparator
            assign eq = (signed'(A) == signed'(B));
            assign lt = (signed'(A) <  signed'(B));
            assign gt = (signed'(A) >  signed'(B));
        end else begin : unsigned_comparator
            assign eq = (A == B);
            assign lt = (A <  B);
            assign gt = (A >  B);
        end
    endgenerate

endmodule
