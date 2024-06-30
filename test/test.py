# TODO: Fix this python testbench for tpu

# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles


@cocotb.test()
async def test_tpu(dut):
    dut._log.info("Start")

    # Set the clock period to 10 ns (100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset the DUT
    dut._log.info("Resetting DUT")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test TPU behavior")

    # Initialize inputs
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Hold reset for a few cycles
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 0

    # Wait for a few clock cycles to allow the DUT to process
    await ClockCycles(dut.clk, 10)

    # Example of checking the contents of unified_mem
    # Adjust the expected values as per your design's expected output
    for i in range(64):
        unified_mem_value = dut.unified_mem[i].value
        dut._log.info(f"unified_mem[{i}] = {unified_mem_value}")

    # Example assertion (change to match your expected values)
    # assert dut.unified_mem[0].value == expected_value, f"unified_mem[0] is {dut.unified_mem[0].value}, expected {expected_value}"

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
