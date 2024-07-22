# SPDX-License-Identifier: Apache-2.0
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

# i think i want to make it so that it only fetches when a flag is high
@cocotb.test() 
async def test_tt_um_tpu(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="us").start())
    
    dut.reset.value = 1
    await ClockCycles(dut.clk, 1)
    dut.reset.value = 0
    await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)

    dut.uio_in.value = 0b00100000 # fetch weight
    await ClockCycles(dut.clk, 1)

    dut.uio_in.value = 0b01000000 # fetch inputs
    await ClockCycles(dut.clk, 1)

    dut.uio_in.value = 0b01100000 # fetch instructions
    await ClockCycles(dut.clk, 1)

    dut.uio_in.value = 0b10000000 # start
    await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)
