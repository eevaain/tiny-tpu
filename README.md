# Tiny-TPU

A minimal Tensor Processing Unit (TPU) inspired by Google's TPUv1.

<p align="center">
  <img src="img/logo.jpg" alt="Logo">
</p>

## Motivation

I recently took on an interesting challenge – reverse-engineering Google's Tensor Processing Unit (TPU) design. Since the real TPU architecture is closed-source, I had to work from the original paper to build a minimal version with a weight-stationary systolic array.

This project was motivated by my belief that it's important for newcomers to explore different AI acceleration approaches beyond just GPUs. Many people want to understand how parallel processing actually works at the hardware level, not just in software.

What's cool is that I started this with basically no digital logic experience – I only began learning Verilog three weeks ago! But I was able to create a working TPU from scratch in that time. I think it demonstrates that hardware design doesn't have to be as intimidating as it might seem.

My hope is that this can serve as an approachable guide for others looking to get into hardware design, especially for AI acceleration. While GPUs are the go-to for ML training right now, I think there's value in understanding alternative architectures too.

## Instructions

This ISA defines the operations for a minimal TPU with a weight-stationary systolic array architecture. Below are the instructions, their purposes, and example usages.

### LOAD_ADDR

Loads the address of a memory partition into a single register.

**Example Usage:**

```verilog
16'b001_0000000001111;  // LOAD_ADDR 0x000F (16th address)
```

### LOAD_WEIGHTS

Loads weights from a weight buffer into the systolic array.

**Example Usage:**

```verilog
16'b010_0000000000000;  // LOAD_WEIGHT (Weights are transferred from weight memory into mmu)
```

### LOAD_INPUT

Loads inputs from the unified buffer into the input setup unit.

**Example Usage:**

```verilog
16'b011_0000000000000;  // LOAD_INPUT
```

### COMPUTE

Performs systolic computation on the loaded weights and inputs.

**Example Usage:**

```verilog
16'b100_0000000000000;  // COMPUTE (Compute starts, systolic operations are automated by here)
```

### STORE_RESULTS

Stores the results from the accumulators back to the unified buffer.

**Example Usage:**

```verilog
16'b101_0000000000000;  // STORE_RESULTS
```

### NOP

End of instructions.

**Example Usage:**

```verilog
16'b000_0000000000000;  // NOP or END (indicate end of instructions)
```

## Future Extensions (TBD)

- **START:** Initial startup instruction.
- **JMP START:** Jump to the START instruction.
- **NEXT_LAYER:** Prepare for the next layer of inputs.

## Example Instruction Sequence

### Initializing and Running the Systolic Array

The following sequence of instructions is loaded directly into the instruction memory. This setup allows for the automatic execution of these instructions by the control unit:

```verilog
instruction_mem[0] = 16'b001_0000000001111;  // LOAD_ADDR 0x000F (16th address)
instruction_mem[1] = 16'b010_0000000000000;  // LOAD_WEIGHT (Weights are transferred from weight memory into mmu)
instruction_mem[2] = 16'b001_0000000011110;  // LOAD_ADDR 0x001E (30th address)
instruction_mem[3] = 16'b011_0000000000000;  // LOAD_INPUT
instruction_mem[4] = 16'b100_0000000000000;  // COMPUTE (Compute starts, systolic operations are automated by here)
instruction_mem[5] = 16'b001_0000000000111;  // LOAD_ADDR 0x0007 (7th address)
instruction_mem[6] = 16'b101_0000000000000;  // STORE_RESULTS
instruction_mem[7] = 16'b000_0000000000000;  // NOP or END (indicate end of instructions)
```

I hope this guide kickstarts your journey into hardware design and demystifies TPU instruction sets! Let me tell you a secret - when I began this project, I was a complete novice in digital logic. I only started learning Verilog three weeks ago! But here's the thing: if I can do it, you absolutely can too.

## Understanding the Systolic Array

The systolic array is a hardware design used to perform matrix multiplications efficiently. It consists of a grid of processing elements (PEs) that compute and pass data through the array in a synchronized manner. This allows for high parallelism and throughput, making it ideal for deep learning tasks.

### How It Works

1. **Data Flow**: Data flows through the array in a pipelined manner. Weights are pre-loaded into the PEs, and inputs are fed from the left.
2. **Processing Elements**: Each PE performs multiply-accumulate operations. It multiplies the incoming data (inputs) with the provided weights and adds the result to an accumulator.
3. **Synchronization**: All PEs operate in lock-step, synchronized by a global clock, ensuring that data moves uniformly across the array.
4. **Output**: The results are accumulated in the final PEs and can be read out after the computation is complete.

### Multiplication in the Systolic Array

In the systolic array, multiplication is tied to the multiply-accumulate (MAC) operations performed by each PE. Each PE takes an input and a weight, multiplies them, and adds the result to an accumulator. The accumulators hold the intermediate sums, which are eventually used to produce the final output matrix.

<p align="center">
  <img src="img/systolic.gif" alt="systolicarray">
</p>

By nature of how the systolic array is set up, each row of the product matrix is stored in its respective accumulator. In the gif above, the output of each row output of a matrix is transferred to a local memory during "OUT" 

<p align="center">
  <img src="img/output.jpg" alt="outputmatrix">
</p>

By visualizing the systolic array, you can see how data flows and interacts within the array, leading to efficient matrix multiplications.

## Understanding the Processing Element

The processing element (PE) is a fundamental building block of the systolic array. Each PE is responsible for performing multiply-accumulate (MAC) operations, which are critical for matrix multiplication.

### How a Processing Element Works:

<p align="center">
  <img src="img/pe.jpg" alt="processingelement">
</p>

1. **Inputs**: Each PE receives an input value (`a_11`) and a weight (`w_11`).
2. **Multiplication**: The input value and weight are multiplied together.
3. **Accumulation**: The result of the multiplication is added to the current value in the accumulator (`acc_in`).
4. **Outputs**: The PE outputs the accumulated result (`acc_in + a_11 * w_11`) and passes the input value to the next PE in the row.

The diagram above illustrates the internal structure of a PE, showing the flow of data through the multiplication and addition units.