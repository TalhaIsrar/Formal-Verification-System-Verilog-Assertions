module controller(
    input clk,
    input rst,
    input start,
    input msb_multiplier,

    output shift,
    output add,
    output init,
    output ready
)

    // State encoding using parameters
    parameter READY = 2'b00,
              CHECK = 2'b01,
              ADD_SHIFT = 2'b10;

    reg [1:0] state, next_state;

    // Counter to count cycles
    reg [2:0] count;

    // FSM state register
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= READY;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            READY:  next_state = (start) ? CHECK : READY;
            CHECK: next_state = ADD_SHIFT;
            ADD_SHIFT:  next_state = (count == 3) ? READY : CHECK;
            default: next_state = READY;
        endcase
    end

    // Counter logic
    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 0;
        else if (state == READY)
            count <= 0;
        else
            count <= count + 1;
    end

    // Output logic 
    always @(*) begin
        init = 1'b0;
        ready = 1'b0;

        case (state)
            READY: begin
                shift = 1'b0;
                add = 1'b0;
                init = start;
                ready = 1'b1;
            end
            CHECK: begin
                shift = 1'b1;
                add = (msb_multiplier) ? 1'b1 : 1'b0;
            end
            DONE: begin
                shift = 1'b0;
                add = 1'b0;
            end
        endcase
    end

endmodule