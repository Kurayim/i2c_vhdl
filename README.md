# FPGA I2C Project with VHDL

## Introduction

This project represents my first experience in digital design implementation using the VHDL language. Initially, my main objective was to implement the I2C protocol in a simulation environment to analyze its behavior theoretically and in software. However, as the development progressed, I realized that simulation alone was not sufficient and that I needed to elevate the project to a more practical and real-world level.

## Hardware Integration

To achieve this, I decided to integrate the **SHT3x temperature and humidity sensor** as an external module, enabling actual hardware interaction. Communication with the sensor was established using the custom-designed `i2c.vhdl` module. After sending the required commands to the sensor, six bytes of data were received. These data were then verified and validated using the `crc_8.v` module to ensure their correctness and integrity.

## Data Processing

One of the main challenges of this project was calculating the temperature and humidity values from the raw data. Due to inherent limitations in performing complex mathematical operations on an FPGA — especially for floating-point calculations — I used Xilinx’s **Floating Point IP core**. In this step, the raw data were first converted from fixed-point to floating-point representation to allow precise computations. After completing the necessary calculations, the results were converted back to fixed-point format for further processing and display.

## Display Output

After obtaining the final and human-readable values of temperature and humidity, these values were converted into character representations suitable for display on a seven-segment display. To achieve this, I utilized the `seven_segment.vhd` module, which handles the conversion of numeric values into formats compatible with seven-segment displays. Ultimately, the project output is presented as numerical temperature and humidity readings shown directly on the seven-segment display, allowing users to view the real-time measured values from the sensor.

## Conclusion

This project not only enhanced my skills in VHDL and modular design but also provided me with practical experience in serial communication (I2C), data integrity verification (CRC), and implementing floating-point calculations on an FPGA.
