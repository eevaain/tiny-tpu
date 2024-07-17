module dump();
    initial begin
        $dumpfile ("mmu.vcd");
        $dumpvars (0, mmu);
        #1;
    end
endmodule
