module dump();
    initial begin
        $dumpfile ("acc.vcd");
        $dumpvars (0, accumulator);
        #1;
    end
endmodule
