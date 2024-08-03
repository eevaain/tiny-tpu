# SPDX-License-Identifier: Apache-2.0
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

# i think i want to make it so that it only fetches when a flag is high
@cocotb.test() 
async def test_dma(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="us").start())
    
    dut.reset.value = 1
    await ClockCycles(dut.clk, 1)

    dut.reset.value = 0
    await ClockCycles(dut.clk, 1)

    dut.reset.value = 0
    await ClockCycles(dut.clk, 1)

    dut.uio_in.value = 0b00100111 # fetch weight "i am holding this down!"
    await ClockCycles(dut.clk, 1)

    dut.uio_in.value = 0b00100111 # fetch weight "i am holding this down!"
    await ClockCycles(dut.clk, 1)

    dut.uio_in.value = 0b00100111 # fetch weight "i am holding this down!"
    await ClockCycles(dut.clk, 1)

    dut.uio_in.value = 0b01000011 # fetch inputs
    await ClockCycles(dut.clk, 1)

    dut.uio_in.value = 0b01100001 # fetch instructions
    await ClockCycles(dut.clk, 1)

    dut.uio_in.value = 0b10000000 # start (only needs to be high once and then tpu should just run on its own)
    await ClockCycles(dut.clk, 1)

    dut.uio_in.value = 0b00000000 # "let go of start really quickly"
    await ClockCycles(dut.clk, 1)

    dut.uio_in.value = 0b00000000 # "let go of start really quickly"
    await ClockCycles(dut.clk, 1)
