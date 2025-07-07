# FPGA-Based I2C Interface with SHT3x Sensor (VHDL)

## Project Overview

This project represents my first hands-on experience with digital design using VHDL. The initial goal was to implement the I2C protocol in a simulation environment to study its theoretical and software-level behavior. However, as the development progressed, I realized that simulation alone was not sufficient. I decided to take the project further and validate it through real hardware implementation.

## Sensor Communication and Data Acquisition

To bring this idea into practice, I integrated the **SHT3x temperature and humidity sensor** as an external module to enable actual hardware interaction. Communication with the sensor was established using a custom-designed `i2c.vhdl` module. After sending the required commands to the sensor, six bytes of data were received and subsequently validated using the `crc_8.v` module to ensure correctness and data integrity.


