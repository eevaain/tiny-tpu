# SPDX-License-Identifier: Apache-2.0
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

async def initialize_instruction_mem(dut):
    # Define the instructions
    instructions = [
        # TODO: test out more addresses to ensure everything works fine. 
        0b001_0000000001111,  # LOAD_ADDR (16th address)
        0b011_0000000000000,  # LOAD_INPUT (take input from unified buffer and transfer to input setup)
        0b001_0000000000000,  # LOAD_ADDR (1st address)
        0b010_0000000000000,  # LOAD_WEIGHT (Weights are transferred from weight memory into mmu)
        0b100_0000000000000,  # COMPUTE (Compute starts, systolic operations are automated by here)
        0b001_0000000000111,  # LOAD_ADDR (load result in 7th address)
        0b101_0000000000000,  # STORE (result is stored in address above within unified buffer)

        # TODO: debug timing of these two instructions!


        0b001_0000000000111,  # LOAD_ADDR (6th address)
        0b111_0000000000000,  # EXT (output data starting from the address specified above)


        0b000_0000000000000,  # NOP or END (indicate end of instructions)
    ]

    # Load the instructions into instruction_mem
    for i, instruction in enumerate(instructions):
        dut.cu.instruction_mem[i].value = instruction
        await RisingEdge(dut.clk)  # Wait for the next clock rising edge to synchronize the write

async def initialize_weight_memory(dut):
    # Hardcoded weights row-wise starting at binary address 0b0011 (3 in decimal)
    # address = 0b0011
    address = 0b0000 # 0th address

    dut.wm.memory[address].value = 3
    dut.wm.memory[address + 1].value = 4
    dut.wm.memory[address + 2].value = 5
    dut.wm.memory[address + 3].value = 6
    await RisingEdge(dut.clk)  # Wait for the next clock rising edge to synchronize the write




# TODO: Replace the function initialize_weight_memory with the function below! 
async def inititialize_weight_memory_REAL(dut):
    dut.fetch_w.value = 0b1 # Select bit for fetchig weight flag turns on
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 0b00000011 # Load in the first weight element in the 2x2 weight matrix
    dut.fetch_w.value = 0b1 # Continue fetching weight
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 0b00000100 # Load in the second weight element in the 2x2 weight matrix
    dut.fetch_w.value = 0b1 # Continue fetching weight
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 0b00000101 # Load in the third weight element in the 2x2 weight matrix
    dut.fetch_w.value = 0b1 # Continue fetching weight
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 0b00000110 # Load in the fourth weight element in the 2x2 weight matrix
    dut.fetch_w.value = 0b1 # Continue fetching weight
    await ClockCycles(dut.clk, 1)

    dut.fetch_w.value = 0b0 # Stop fetching weight!
    await ClockCycles(dut.clk, 1)






async def initialize_unified_mem(dut):
    # Hardcoded dummy values row-wise starting at binary address 0b10000 (16 in decimal)
    address = 0b01111

    dut.ub.unified_mem[address].value = 11
    dut.ub.unified_mem[address + 1].value = 12
    dut.ub.unified_mem[address + 2].value = 21
    dut.ub.unified_mem[address + 3].value = 22
    await RisingEdge(dut.clk)  # Wait for the next clock rising edge to synchronize the write

@cocotb.test()
async def test_tpu(dut):
    # Start the clock
    cocotb.start_soon(Clock(dut.clk, 10, units="us").start())

    # Reset the DUT
    dut.reset.value = 1
    dut.start.value = 0  # Ensure start is low during reset
    await ClockCycles(dut.clk, 1)
    dut.reset.value = 0
    await ClockCycles(dut.clk, 1)

    # Initialize the instruction memory
    await initialize_instruction_mem(dut)
    # await inititialize_weight_memory_REAL(dut)
    # Initialize the unified memory with dummy inputs
    await initialize_unified_mem(dut)
    # Initialize the weights
    await initialize_weight_memory(dut)

    # Assert the start signal to begin execution
    dut.start.value = 1
    await ClockCycles(dut.clk, 1)  # Wait one cycle for the start signal to be registered
    dut.start.value = 0  # De-assert start signal

    for cycle in range(29):
        await RisingEdge(dut.clk)
        dut._log.info(f"Cycle {cycle + 1}:")

        # Print values of the accumulators for every clock cycle in decimal
        acc1_mem_0_val = int(dut.acc1.acc_mem[0].value)
        acc1_mem_1_val = int(dut.acc1.acc_mem[1].value)
        acc2_mem_0_val = int(dut.acc2.acc_mem[0].value)
        acc2_mem_1_val = int(dut.acc2.acc_mem[1].value)

        dut._log.info(f"acc1_mem_0 = {acc1_mem_0_val}")
        dut._log.info(f"acc1_mem_1 = {acc1_mem_1_val}")
        dut._log.info(f"acc2_mem_0 = {acc2_mem_0_val}")
        dut._log.info(f"acc2_mem_1 = {acc2_mem_1_val}")
        dut._log.info(f"-----------------------------")

    # Print all 64 values of the unified memory from unified_buffer after the loop
    for i in range(32):
        unified_mem_val = int(dut.ub.unified_mem[i].value)
        dut._log.info(f"unified_mem[{i}] = {unified_mem_val}")
    

