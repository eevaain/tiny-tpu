# SPDX-License-Identifier: Apache-2.0
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

@cocotb.test()
async def test_tpu(dut):
    # Start the clock
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Reset the DUT
    dut.reset.value = 1
    await ClockCycles(dut.clk, 2)
    dut.reset.value = 0
    await ClockCycles(dut.clk, 2)

    # Apply test stimulus if any (none in this case)
    dut._log.info("No test stimulus to apply as there are no inputs")

    # Wait for a few clock cycles to observe the behavior using a for loop
    # IMPORTANT BELOW: 
    # 12 clock cycles for accumulators to finish 2*2 matmul
    # 14 clock cycles (+2) because i have TWO instructions AFTER my compute instruction lmao
    for cycle in range(14):
        await RisingEdge(dut.clk)
        dut._log.info(f"Cycle {cycle + 1}:")

        # Print values of the accumulators for every clock cycle in decimal
        acc1_mem_0_val = int(dut.uut.acc1.acc_mem_0.value)
        acc1_mem_1_val = int(dut.uut.acc1.acc_mem_1.value)
        acc2_mem_0_val = int(dut.uut.acc2.acc_mem_0.value)
        acc2_mem_1_val = int(dut.uut.acc2.acc_mem_1.value)

        dut._log.info(f"acc1_mem_0 = {acc1_mem_0_val}")
        dut._log.info(f"acc1_mem_1 = {acc1_mem_1_val}")
        dut._log.info(f"acc2_mem_0 = {acc2_mem_0_val}")
        dut._log.info(f"acc2_mem_1 = {acc2_mem_1_val}")
        dut._log.info(f"-----------------------------")

    # Print all 64 values of the unified memory from unified_buffer after the loop
    for i in range(64):
        unified_mem_val = int(dut.uut.ub.unified_mem[i].value)
        dut._log.info(f"unified_mem[{i}] = {unified_mem_val}")
