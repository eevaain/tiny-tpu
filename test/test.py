# SPDX-License-Identifier: Apache-2.0
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

async def initialize_instruction_mem(dut):
    # Define the instructions
    instructions = [
        0b001_0000000001111,  # LOAD_ADDR 0x000F (16th address)
        0b010_0000000000000,  # LOAD_WEIGHT (Weights are transferred from weight memory into mmu)
        0b001_0000000011110,  # LOAD_ADDR 0x001E (30th address)
        0b011_0000000000000,  # LOAD_INPUT
        0b100_0000000000000,  # COMPUTE (Compute starts, systolic operations are automated by here)
        0b001_0000000000111,  # LOAD_ADDR 0x0007 (7th address)
        0b101_0000000000000,  # STORE
        0b000_0000000000000,  # NOP or END (indicate end of instructions)
    ]

    # Load the instructions into instruction_mem
    for i, instruction in enumerate(instructions):
        dut.uut.cu.instruction_mem[i].value = instruction
        await RisingEdge(dut.clk)  # Wait for the next clock rising edge to synchronize the write

@cocotb.test()
async def test_tpu(dut):
    # Start the clock
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Reset the DUT
    dut.reset.value = 1
    dut.start.value = 0  # Ensure start is low during reset
    await ClockCycles(dut.clk, 1)
    dut.reset.value = 0
    await ClockCycles(dut.clk, 1)

    # Initialize the instruction memory
    await initialize_instruction_mem(dut)

    # Apply test stimulus if any (none in this case)
    dut._log.info("No test stimulus to apply as there are no inputs")

    # Assert the start signal to begin execution
    dut.start.value = 1
    await ClockCycles(dut.clk, 1)  # Wait one cycle for the start signal to be registered
    dut.start.value = 0  # De-assert start signal

    #IMPORTANT BELOW:
    # 11 clock cycles pass by here (2 from reset, 8 from loading instructions, 1 from asserting start flag)

    # IMPORTANT BELOW: 
    # 12 clock cycles for accumulators to finish 2*2 matmul
    # 14 clock cycles (+2) because I have TWO instructions AFTER my compute instruction

    for cycle in range(15):
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
