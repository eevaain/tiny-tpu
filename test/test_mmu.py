import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

@cocotb.test()
async def test_mmu(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="us").start())

    dut.reset.value = 1
    await ClockCycles(dut.clk, 1)
    dut.reset.value = 0
    await ClockCycles(dut.clk, 1)
    dut.load_weight.value = 1
    dut.weight1.value = 3
    dut.weight2.value = 4
    dut.weight3.value = 5
    dut.weight4.value = 6
    await ClockCycles(dut.clk, 1)
    dut.valid.value = 1

    await ClockCycles(dut.clk, 1)

    dut.a_in1.value = 11
    dut.a_in2.value = 0
    await ClockCycles(dut.clk, 1)

    dut.a_in1.value = 12
    dut.a_in2.value = 21
    await ClockCycles(dut.clk, 1)

    dut.a_in1.value = 0
    dut.a_in2.value = 22
    await ClockCycles(dut.clk, 1)
    
    dut.a_in1.value = 0
    dut.a_in2.value = 0
    await ClockCycles(dut.clk, 1)

    dut.a_in1.value = 0
    dut.a_in2.value = 0
    await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)
    

