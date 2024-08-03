module dump();
    initial begin
        $dumpfile ("dma.vcd");
        $dumpvars (0, dma);
        #1;
    end
endmodule
