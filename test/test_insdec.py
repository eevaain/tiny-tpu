# SPDX-License-Identifier: Apache-2.0
import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def test_insdec(dut):

    await Timer(10, units="ns")
    await Timer(10, units="ns")

    dut.instruction.value = 0b0010000000011111
    await Timer(10, units="ns")
    await Timer(10, units="ns")
    await Timer(10, units="ns")


# Instead of waiting for clock cycles, we use Timer 
# to wait for a small amount of time (1 nanosecond) 
# to allow signals to propagate through the combinational logic.