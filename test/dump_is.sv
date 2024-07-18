module dump();
    initial begin
        $dumpfile ("is.vcd");
        $dumpvars (0, input_setup);
        #1;
    end
endmodule
