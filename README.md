# FPGA I2C Project with VHDL

## Introduction

This project represents my first experience in digital design implementation using the VHDL language. Initially, my main objective was to implement the I2C protocol in a simulation environment to analyze its behavior theoretically and in software. However, as the development progressed, I realized that simulation alone was not sufficient and that I needed to elevate the project to a more practical and real-world level.

## Hardware Integration

To achieve this, I decided to integrate the **SHT3x temperature and humidity sensor** as an external module, enabling actual hardware interaction. Communication with the sensor was established using the custom-designed `i2c.vhdl` module. After sending the required commands to the sensor, six bytes of data were received. These data were then verified and validated using the `crc_8.v` module to ensure their correctness and integrity.


