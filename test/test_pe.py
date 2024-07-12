import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_processing_element(dut):
    """Test the processing_element module."""

    # Reset the DUT
    dut.reset.value = 1
    dut.load_weight.value = 0
    dut.valid.value = 0
    dut.a_in.value = 0
    dut.weight.value = 0
    dut.acc_in.value = 0

    await Timer(10, units="ns")
    dut.reset.value = 0

    # Load weight
    dut.load_weight.value = 1
    dut.weight.value = 10
    await Timer(10, units="ns")
    dut.load_weight.value = 0

    # Send a_in and acc_in with valid signal
    dut.a_in.value = 5
    dut.acc_in.value = 2
    dut.valid.value = 1

    await Timer(10, units="ns")

    # Deactivate the valid signal
    dut.valid.value = 0
    await Timer(10, units="ns")

    # Send new a_in and acc_in with valid signal
    dut.a_in.value = 3
    dut.acc_in.value = 4
    dut.valid.value = 1

    await Timer(10, units="ns")
    # Deactivate the valid signal
    dut.valid.value = 0
    await Timer(10, units="ns")
