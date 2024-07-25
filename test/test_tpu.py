# SPDX-License-Identifier: Apache-2.0
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

async def initialize_instruction_mem(dut):
    # Define the instructions in an array
    instructions = [
        0b001_01111,  # LOAD_ADDR (16th address)
        0b011_00000,  # LOAD_INPUT (take input from unified buffer and transfer to input setup)
        0b001_00000,  # LOAD_ADDR (1st address)
        0b010_00000,  # LOAD_WEIGHT (Weights are transferred from weight memory into mmu)
        0b100_00000,  # COMPUTE (Compute starts, systolic operations are automated by here)
        0b001_00111,  # LOAD_ADDR (load result in 8th address)
        0b101_00000,  # STORE (result is stored in address above within unified buffer)
        0b001_01001,  # LOAD_ADDR (10th address: which means only last two product matrix elements will be outputted)
        0b111_00000,  # EXT (output data off-chip, starting from the address specified above)
        0b000_00000   # NOP or END (indicate end of instructions)
    ]

    # By separating the instructions into ext fetch and internal program execution...
    # ...I can fetch weights and inputs during runtime!

    # Start fetching instructions
    dut.fetch_ins.value = 1
    await ClockCycles(dut.clk, 1)

    # Load the instructions into the instruction memory
    for ins in instructions:
        dut.ui_in.value = ins
        dut.fetch_ins.value = 1
        await ClockCycles(dut.clk, 1)

    # Stop receiving instructions
    dut.fetch_ins.value = 0
    await ClockCycles(dut.clk, 1)



async def inititialize_weight_memory(dut):
    # Define the weight elements in an array
    weights = [
        0b00000011,  # First weight element in the 2x2 weight matrix (3)
        0b00000100,  # Second weight element in the 2x2 weight matrix (4)
        0b00000101,  # Third weight element in the 2x2 weight matrix (5)
        0b00000110   # Fourth weight element in the 2x2 weight matrix (6)
    ]

    # Start fetching weights
    dut.fetch_w.value = 1
    await ClockCycles(dut.clk, 1)

    # Load the weights into the weight memory
    for weight in weights:
        dut.ui_in.value = weight
        dut.fetch_w.value = 1
        await ClockCycles(dut.clk, 1)

    # Stop fetching weights
    dut.fetch_w.value = 0
    await ClockCycles(dut.clk, 1)



async def initialize_unified_mem(dut):
    # Hardcoded dummy values row-wise starting at binary address 0b10000 (16 in decimal)
    address = 0b01111 # TODO: create external addressing which is sent directly from host computer
                    # which communicates with the tpu. is this considered as a DMA controller???
                    # therefore i will have 2 types of instructions:
                    # 1. instructions which directly react to host computer
                    # 2. instructions which only execute when start flag is triggered 
                    # probably should find a more professional term to dub this process...

    dut.ub.unified_mem[address].value = 11
    dut.ub.unified_mem[address + 1].value = 12
    dut.ub.unified_mem[address + 2].value = 21
    dut.ub.unified_mem[address + 3].value = 22
    await RisingEdge(dut.clk)  # Wait for the next clock rising edge to synchronize the write



@cocotb.test()
async def test_tpu(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="us").start()) # Start the clock

    dut.reset.value = 1  # Reset the DUT
    dut.start.value = 0  # Ensure start is low during reset
    await ClockCycles(dut.clk, 1)
    dut.reset.value = 0
    await ClockCycles(dut.clk, 1)

    await initialize_instruction_mem(dut)  # Initialize instructions
    await initialize_unified_mem(dut) # Initialize inputs
    await inititialize_weight_memory(dut) # Initialize weights

    # print("Weights within first four addresses: ")
    # print(int(dut.wm.memory[0].value))
    # print(int(dut.wm.memory[1].value))
    # print(int(dut.wm.memory[2].value))
    # print(int(dut.wm.memory[3].value))

    dut.start.value = 1 # Assert the start signal to begin execution
    await ClockCycles(dut.clk, 1)  # Wait one cycle for the start signal to be registered
    dut.start.value = 0  # De-assert start signal

    for cycle in range(28): # results dont change after a specific clk cycle but i forgot
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
    

