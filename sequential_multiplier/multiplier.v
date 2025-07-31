module multiplier(
    input clk,
    input rst,

    input start,
    input [3:0] multiplier,
    input [3:0] multiplicand,
    
    output [7:0] product,
    output ready
)

    reg [3:0] internal_m, internal_q;
    wire [4:0] sum, accumulator_result;

    wire shift, add, init;
    wire serial_input;

    controller control(
        .clk(clk),
        .rst(rst),
        .start(start),
        .msb_multiplier(internal_q[0]),
        .shift(shift),
        .add(add),
        .init(init),
        .ready(ready)
    );

    adder adder1(
        .a(accumulator_result[3:0]),
        .b(internal_m),
        .co_sum(sum)
    );

    // Multiplicand Register
    register Multiplicand(
        .clk(clk),
        .rst(rst),
        .shift(1'b0),
        .load(init)
        .clear(1'b0),
        .serial_in(1'b0),
        .data_in(multiplicand),
        .data_out(internal_m)
    );

    // Multiplier Register
    register Multiplier(
        .clk(clk),
        .rst(rst),
        .shift(shift),
        .load(init)
        .clear(1'b0),
        .serial_in(serial_input),
        .data_in(multiplier),
        .data_out(internal_q)
    );

    // Accumulator Register
    register #(5) Accumulator(
        .clk(clk),
        .rst(rst),
        .shift(shift),
        .load(add)
        .clear(init),
        .serial_in(1'b0),
        .data_in(sum),
        .data_out(accumulator_result)
    );

    assign serial_input = (add & sum[0]) | (~add & accumulator_result[0]);
    assign product = {accumulator_result[3:0], internal_q};

endmodule
