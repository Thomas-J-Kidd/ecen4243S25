// Flip-flop modules with synchronous reset

module flopr #(
    parameter WIDTH = 8
) (
    input  logic             clk, reset,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);
   
    always_ff @(posedge clk, posedge reset)
        if (reset) q <= 0;
        else       q <= d;
   
endmodule

module flopenr #(
    parameter WIDTH = 8
) (
    input  logic             clk, reset, en,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);
   
    always_ff @(posedge clk, posedge reset)
        if (reset)  q <= 0;
        else if (en) q <= d;
   
endmodule
