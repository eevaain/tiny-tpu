# SPDX-License-Identifier: Apache-2.0
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles

@cocotb.test()

async def test_tpu(dut):
    # Start the clock
    cocotb.start_soon(Clock(dut.clk, 12, units="ns").start())

    # Reset the DUT
    dut.reset.value = 1
    await ClockCycles(dut.clk, 2)
    dut.reset.value = 0
    await ClockCycles(dut.clk, 2)

    # Apply test stimulus if any (none in this case)
    dut._log.info("No test stimulus to apply as there are no inputs")

    # Wait for a few clock cycles to observe the behavior
    await ClockCycles(dut.clk, 12)
    
    # Check internal states or outputs if any (replace 'some_output' with actual signal)
    dut._log.info("Checking internal states or outputs if any")