module adder (
    input  [3:0] a, 
    input  [3:0] b,
    output [4:0] co_sum
);
    // Append a 0 MSB so that sum has carry out
    assign co_sum = {1'b0, a} + {1'b0, b};

endmodule