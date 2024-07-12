module dump();
    initial begin
        $dumpfile ("tpu.vcd");
        $dumpvars (0, tpu);
        #1;
    end
endmodule
