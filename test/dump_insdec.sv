module dump();
    initial begin
        $dumpfile ("insdec.vcd");
        $dumpvars (0, insdec);
        #1;
    end
endmodule
