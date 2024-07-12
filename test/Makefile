# Makefile for running Cocotb tests
SIM ?= icarus

# Verilog source files
VERILOG_SOURCES = ../src/accumulator.sv \
                  ../src/control_unit.sv \
                  ../src/input_setup.sv \
                  ../src/mmu.sv \
                  ../src/processing_element.sv \
                  ../src/tpu.sv \
                  ../src/unified_buffer.sv \
                  ../src/weight_memory.sv

# Set the default top-level module and test module (can be overridden on the command line)
TOPLEVEL_LANG = verilog

TOPLEVEL ?= tpu
MODULE ?= test_tpu

# TOPLEVEL ?= processing_element
# MODULE ?= test_pe


include $(shell cocotb-config --makefiles)/Makefile.sim

# test_fadd: MODULE=test_tpu TOPLEVEL=tpu $(shell cocotb-config --makefiles)/Makefile.sim
