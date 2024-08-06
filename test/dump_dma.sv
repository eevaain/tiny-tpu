module dump();
    initial begin
        $dumpfile ("dma.vcd");
        $dumpvars (0, dma);

        $dumpvars(0, dma.test_storage[0]);
        $dumpvars(0, dma.test_storage[1]);
        $dumpvars(0, dma.test_storage[2]);
        $dumpvars(0, dma.test_storage[3]);


        #1;
    end
endmodule
