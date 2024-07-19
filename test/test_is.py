import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

@cocotb.test()
async def test_is(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="us").start())

    dut.reset.value = 1
    await ClockCycles(dut.clk, 1)

    dut.reset.value = 0
    await ClockCycles(dut.clk, 1)

    dut.a11.value = 11
    dut.a12.value = 12
    dut.a21.value = 21
    dut.a22.value = 22
    await ClockCycles(dut.clk, 1)

    dut.valid.value = 1

    await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)
