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