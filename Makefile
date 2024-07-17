# FPGA variables
PROJECT = fpga/tpu_project
SOURCES = src/tpu.sv src/accumulator.sv src/control_unit.sv src/input_setup.sv src/mmu.sv src/processing_element.sv src/unified_buffer.sv src/weight_memory.sv 
ICEBREAKER_DEVICE = up5k
ICEBREAKER_PIN_DEF = fpga/icebreaker.pcf
ICEBREAKER_PACKAGE = sg48
SEED = 1

# COCOTB variables
export COCOTB_REDUCED_LOG_FMT=1
export PYTHONPATH := test:$(PYTHONPATH)
export LIBPYTHON_LOC=$(shell cocotb-config --libpython)

all: test_tpu

# if you run rules with NOASSERT=1 it will set PYTHONOPTIMIZE, which turns off assertions in the tests
test_tpu:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -o sim_build/sim.vvp -s tpu -s dump -g2012 src/tpu.sv test/dump_tpu.sv src/accumulator.sv src/control_unit.sv src/input_setup.sv src/mmu.sv src/processing_element.sv src/unified_buffer.sv src/weight_memory.sv
	PYTHONOPTIMIZE=${NOASSERT} MODULE=test.test_tpu vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp
	! grep failure results.xml

test_insdec:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -o sim_build/sim.vvp -s insdec -s dump -g2012 src/insdec.sv test/dump_insdec.sv 
	PYTHONOPTIMIZE=${NOASSERT} MODULE=test.test_insdec vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp
	! grep failure results.xml

test_mmu:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -o sim_build/sim.vvp -s mmu -s dump -g2012 src/mmu.sv test/dump_mmu.sv src/processing_element.sv
	PYTHONOPTIMIZE=${NOASSERT} MODULE=test.test_mmu vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp
	! grep failure results.xml
	

# show_%: %.vcd %.gtkw (%.gtkw file allows me to config my waveform) but MUST have the gtkw file to work
show_%: %.vcd %.gtkw
	gtkwave $^

# FPGA recipes
show_synth_%: src/%.sv
	yosys -p "read_verilog $<; proc; opt; show -colors 2 -width -signed"

%.json: $(SOURCES)
	yosys -l fpga/yosys.log -p 'synth_ice40 -top tpu -json $(PROJECT).json' $(SOURCES)

%.asc: %.json $(ICEBREAKER_PIN_DEF)
	nextpnr-ice40 -l fpga/nextpnr.log --seed $(SEED) --freq 20 --package $(ICEBREAKER_PACKAGE) --$(ICEBREAKER_DEVICE) --asc $@ --pcf $(ICEBREAKER_PIN_DEF) --json $

%.bin: %.asc
	icepack $< $@

prog: $(PROJECT).bin
	iceprog $

# general recipes
lint:
	verible-verilog-lint src/*sv --rules_config verible.rules

clean:
	rm -rf *vcd sim_build fpga/*log fpga/*bin test/__pycache__

.PHONY: clean