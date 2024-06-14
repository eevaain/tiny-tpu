# Instruction Set Architecture (ISA) for Minimal TPU

This ISA defines the operations for a minimal TPU with a weight-stationary systolic array architecture. Below are the instructions, their purposes, and example usages.

## Instructions

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

### COMPUTE
Performs systolic computation on the loaded weights and inputs.

**Example Usage:**
```verilog
instruction = 16'b100_0000000000000;  // COMPUTE
```

## Future Extensions (TBD)

- **LOAD_INPUTS:** Load inputs from a global on-chip memory.
- **START:** Initial startup instruction.
- **JMP START:** Jump to the START instruction.
- **STORE_RESULTS:** Store results back to global on-chip memory.
- **NEXT_LAYER:** Prepare for the next layer of inputs.

## Example Instruction Sequence

### Initializing and Running the Systolic Array
```verilog
// Load base address for weights
instruction = 16'b001_0000000001111;  // LOAD_ADDR 0x000F

// Load weights into systolic array
instruction = 16'b010_0000000000000;  // LOAD_WEIGHT

// Perform systolic computation
instruction = 16'b100_0000000000000;  // COMPUTE
```

## Notes

- Ensure that the sequence of instructions is followed correctly to achieve the desired computation.
- Each instruction has a specific format and purpose within the TPU's operation.

This instruction set provides a structured way to control and utilize the minimal TPU for various computational tasks, ensuring efficient and effective operations.