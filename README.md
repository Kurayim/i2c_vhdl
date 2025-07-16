## Project Overview

This project represents my first hands-on experience with digital design using VHDL. The initial goal was to implement the I2C protocol in a simulation environment to study its theoretical and software-level behavior. However, as the development progressed, I realized that simulation alone was not sufficient. I decided to take the project further and validate it through real hardware implementation.





![ChatGPT Image Jul 6, 2025, 10_43_28 PM](https://github.com/user-attachments/assets/44e79e31-375d-472c-9c5c-3b00418177b6)








## Sensor Communication and Data Acquisition

To bring this idea into practice, I integrated the **SHT3x temperature and humidity sensor** as an external module to enable actual hardware interaction. Communication with the sensor was established using a custom-designed `i2c.vhdl` module. After sending the required commands to the sensor, six bytes of data were received and subsequently validated using the `crc_8.v` module to ensure correctness and data integrity.

## Data Conversion and Calculation

A major challenge in this project was converting the raw data into meaningful temperature and humidity values. Due to inherent limitations in performing complex mathematical operations on an FPGA — especially floating-point calculations — I utilized Xilinx’s **Floating Point IP core**. In this phase, the raw data were first converted from fixed-point to floating-point format to enable precise computations. After completing the necessary calculations, the results were converted back to fixed-point representation for subsequent stages.

## Displaying Measured Values

After obtaining the final, human-readable values of temperature and humidity, it was necessary to convert these values into character format suitable for display on a seven-segment display. For this purpose, I used the seven_segment.vhd module, which handles the conversion of numerical values into a format compatible with seven-segment displays.

The final output of this module allows users to easily and clearly view the real-time temperature and humidity values on the display. However, due to a malfunction in the seven-segment display used in this project, I decided to send the temperature and humidity data to my laptop via the UART protocol and display them in a terminal instead. This task was accomplished using the tx.v module.

## Key Takeaways

This project not only strengthened my skills in VHDL and modular hardware design but also provided practical experience in serial communication (I2C), data integrity verification (CRC), and floating-point computation implementation on FPGA platforms.




https://github.com/user-attachments/assets/b26396ac-b3b2-48ba-b3ca-601e7841eccb

