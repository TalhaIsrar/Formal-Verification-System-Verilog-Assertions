module register #(
    parameter SIZE = 4
) (
    input clk,
    input rst,
    input shift,
    input load,
    input clear,
    input serial_in,
    input [SIZE-1 : 0] data_in,

    output reg [SIZE-1 : 0] data_out 
)

    // Load and shift register
    always @(posedge clk) begin
        if (rst) 
            data_out <= 0;
        else begin
            if (clear)   
                data_out <= 0;
            else if (load & shift)
                data_out <= {serial_in, data_in[SIZE - 1:1]};
            else if (load)
                data_out <= data_in;
            else if (shift)
                data_out <= {serial_in, data_out[SIZE - 1:1]};
        end
    end 

endmodule