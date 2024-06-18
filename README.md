# Tiny-TPU

A minimal Tensor Processing Unit (TPU) inspired by Google's TPUv1.

<p align="center">
  <img src="img/logo.jpg" alt="Logo">
</p>

## Motivation:

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
instruction = 16'b001_0000000001111;  // LOAD_ADDR 0x000F
```

### LOAD_WEIGHTS
Loads weights from a weight buffer into the systolic array.

**Example Usage:**
```verilog
instruction = 16'b010_0000000000000;  // LOAD_WEIGHT
```

### LOAD_INPUT
Loads inputs from the unified buffer into the input setup unit.

**Example Usage:**
```verilog
instruction = 16'b011_0000000000000;  // LOAD_INPUT
```

### COMPUTE
Performs systolic computation on the loaded weights and inputs.

**Example Usage:**
```verilog
instruction = 16'b100_0000000000000;  // COMPUTE
```

### STORE_RESULTS
Stores the results from the accumulators back to the unified buffer.

**Example Usage:**
```verilog
instruction = 16'b101_0000000000000;  // STORE_RESULTS
```

## Future Extensions (TBD)

- **START:** Initial startup instruction.
- **JMP START:** Jump to the START instruction.
- **NEXT_LAYER:** Prepare for the next layer of inputs.

## Example Instruction Sequence

### Initializing and Running the Systolic Array
```verilog
// Load base address for weights
instruction = 16'b001_0000000001111;  // LOAD_ADDR 0x000F
#10;

// Load weights into systolic array
instruction = 16'b010_0000000000000;  // LOAD_WEIGHT
#10;

// Load base address for activation inputs
instruction = 16'b001_0000000011110;  // LOAD_ADDR 0x001E
#10;

// Activation inputs are transferred from unified buffer to input setup unit
instruction = 16'b011_0000000000000;  // LOAD_INPUT 
#10;

// Convolutions begin within array
instruction = 16'b100_0000000000000;  // COMPUTE
#10;

// Mandatory empty input to allow partial sums to go into accumulator
#10; 
#10; 
#10;
#10;
#10;

instruction = 16'b001_0000000000111;  // LOAD_ADDR 0x0001 
#10;

// Transfer accumulator product matrix rows into the unified buffer 
instruction = 16'b101_0000000000000;  // STORE_RESULTS
#10;
```

I hope this guide kickstarts your journey into hardware design and demystifies TPU instruction sets! Let me tell you a secret - when I began this project, I was a complete novice in digital logic. I only started learning Verilog three weeks ago! But here's the thing: if I can do it, you absolutely can too.