# FPGA-Based I2C Interface with SHT3x Sensor (VHDL)

## Project Overview

This project represents my first hands-on experience with digital design using VHDL. The initial goal was to implement the I2C protocol in a simulation environment to study its theoretical and software-level behavior. However, as the development progressed, I realized that simulation alone was not sufficient. I decided to take the project further and validate it through real hardware implementation.

## Sensor Communication and Data Acquisition

To bring this idea into practice, I integrated the **SHT3x temperature and humidity sensor** as an external module to enable actual hardware interaction. Communication with the sensor was established using a custom-designed `i2c.vhdl` module. After sending the required commands to the sensor, six bytes of data were received and subsequently validated using the `crc_8.v` module to ensure correctness and data integrity.

## Data Conversion and Calculation

A major challenge in this project was converting the raw data into meaningful temperature and humidity values. Due to inherent limitations in performing complex mathematical operations on an FPGA — especially floating-point calculations — I utilized Xilinx’s **Floating Point IP core**. In this phase, the raw data were first converted from fixed-point to floating-point format to enable precise computations. After completing the necessary calculations, the results were converted back to fixed-point representation for subsequent stages.

## Displaying Measured Values

Once the final, human-readable values of temperature and humidity were obtained, they needed to be converted into character representations suitable for display on a seven-segment display. To accomplish this, I used the `seven_segment.vhd` module, which handles the conversion of numeric values to a format compatible with seven-segment displays. The final output allows users to easily read real-time temperature and humidity measurements directly on the display.

## Key Takeaways

This project not only strengthened my skills in VHDL and modular hardware design but also provided practical experience in serial communication (I2C), data integrity verification (CRC), and floating-point computation implementation on FPGA platforms.


