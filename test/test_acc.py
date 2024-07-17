import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

#VERIFIED FUNCIONALITY ✅

@cocotb.test()
async def test_acc(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="us").start())

    dut.reset.value = 1
    await ClockCycles(dut.clk, 1)

    dut.reset.value = 0
    await ClockCycles(dut.clk, 1)

    dut.valid.value = 1
    await ClockCycles(dut.clk, 1)
   
    dut.acc_in.value = 0
    await ClockCycles(dut.clk, 1)

    dut.acc_in.value = 0
    await ClockCycles(dut.clk, 1)

    dut.acc_in.value = 0
    await ClockCycles(dut.clk, 1)

    dut.acc_in.value = 117  
    await ClockCycles(dut.clk, 1)

    dut.acc_in.value = 124
    await ClockCycles(dut.clk, 1)

    dut.acc_in.value = 69
    await ClockCycles(dut.clk, 1)

    dut.acc_in.value = 96
    await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)