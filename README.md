# Introduction
This is a personal repository with source code for makerdiary nrf52840-mdk-usb-dongle using **CMake** and the **nRF5-SDK**. The current examples are importables in **CLion** and generates *.uf2*, *.hex* and *.bin* files ready to flash on the dongle.

# Documentation for **nRF52840**
Product Specification v1.2: [link](https://infocenter.nordicsemi.com/pdf/nRF52840_PS_v1.2.pdf)  
Makerdiary nrf52840-mdk-usb-dongle: [link](https://github.com/makerdiary/nrf52840-mdk-usb-dongle)

# Linker Script's Memory Organization

All credits of this section to *AndreasF* for his [guide](https://devzone.nordicsemi.com/nordic/short-range-guides/b/getting-started/posts/adjustment-of-ram-and-flash-memory)

For your Application to run correct, the RAM and FLASH start addresses must be correct. There are three things you should consider when you are defining these addresses in your configuration.

- The Application does not use a SoftDevice or a Master Boot Record (MBR)
- The Application only uses a Master Boot Record (MBR)
- The Application uses a SoftDevice

## 1. The Application does not use a SoftDevice nor MBR
If the Application does not use a SoftDevice or a Master Boot Record, then the start address for the FLASH memory should always be set to **0x0** and the start address for the RAM should be set to **0x2000 0000**.

## 2. The Application only uses a MBR
For nRF52 devices, if the Application only uses a MBR, then the start address for the FLASH memory should always be set to **0x1000** and the start address for the RAM should be set to **0x2000 0008**.

## 3. The Application uses a SoftDevice
If your Application uses a SoftDevice the start address for the FLASH memory must be set to the correct value for the corresponding SoftDevice, otherwise the Application will not run. This is because the SoftDevice expects the Application to start at one specific address. The RAM start address on the other hand can vary depending on the number of features used in the SoftDevice, but it has always a lowest possible starting address. If you are unsure on what the correct start address for the RAM should be, then it is possible to find this value using  SoftDevice Handler library.

*Table 1* below show different start addresses for RAM and FLASH in some of the different SoftDevice versions. As mentioned above, the value of the start address for RAM is the lowest value possible to set for the Application to run. It may not perform as expected if your SoftDevice uses many features.

|**SoftDevice**|**Version**|**Minimum RAM Start**|**FLASH start**|
|:---:|:---:|:---:|:---:|
|S110|8.0.0|0x20002000|0x18000|
|S112|5.1.0-2.alpha|0x20000E98|0x19000|
|S112|5.1.0|0x20000EB8|0x18000|
|S112|6.0.0|0x20000F70|0x19000|
|S112|6.1.0|0x20000F70|0x19000|
|S112|6.1.1|0x20000F70|0x19000|
|S112|7.0.0|0x20000EB8|0x19000|
|S113|7.0.0|0x20001198|0x1C000|
|S113|7.1.0|0x20001198|0x1C000|
|S113|7.2.0|0x20001198|0x1C000|
|S120|2.0.0|0x20002800|0x1D000|
|S120|2.1.0|0x20002800|0x1D000|
|S130|1.0.0|0x20002800|0x1C000|
|S130|2.0.0-4.alpha|0x20001268|0x1C000|
|S130|2.0.0-7.alpha|0x20001230|0x1B000|
|S130|2.0.0-8.alpha|0x200012B8|0x1B000|
|S130|2.0.0|0x200013C8|0x1B000|
|S130|2.0.1|0x200013C8|0x1B000|
|S132|1.0.0-2.alpha|0x20002800|0x1F000|
|S132|1.0.0-3.alpha|0x20002800|0x1F000|
|S132|2.0.0-4.alpha|0x20001268|0x1F000|
|S132|2.0.0-7.alpha|0x20001230|0x1B000|
|S132|2.0.0-8.alpha|0x200012B8|0x1C000|
|S132|2.0.0|0x200013C8|0x1C000|
|S132|2.0.1|0x200013C8|0x1C000|
|S132|3.0.0-1.alpha|0x200010E0|0x1D000|
|S132|3.0.0-2.alpha|0x20001660|0x1F000|
|S132|3.0.0|0x200019C0|0x1F000|
|S132|3.1.0|0x200019C0|0x1F000|
|S132|4.0.0-1.alpha|0x20001470|0x1F000|
|S132|4.0.0-2.alpha|0x20001460|0x1F000|
|S132|4.0.0|0x200013C0|0x1F000|
|S132|4.0.2|0x200013C0|0x1F000|
|S132|4.0.3|0x200013C0|0x1F000|
|S132|4.0.4|0x200013C0|0x1F000|
|S132|4.0.5|0x200013C0|0x1F000|
|S132|5.0.0-1.alpha|0x200019C0|0x20000|
|S132|5.0.0-2.alpha|0x20001478|0x21000|
|S132|5.0.0-3.alpha|0x20001368|0x23000|
|S132|5.0.0|0x200014B8|0x23000|
|S132|5.0.1|0x20001380|0x23000|
|S132|6.0.0|0x20001628|0x26000|
|S132|6.1.0|0x20001628|0x26000|
|S132|6.1.1|0x20001628|0x26000|
|S132|7.0.0|0x20001668|0x26000|
|S140|5.0.0-1.alpha|0x200019C0|0x21000|
|S140|5.0.0-2.alpha|0x20001468|0x21400|
|S140|5.0.0-3.alpha|0x200014B8|0x24000|
|S140|6.0.0-6.alpha|0x20001530|0x25000|
|S140|6.0.0|0x20001628|0x26000|
|S140|6.1.0|0x20001628|0x26000|
|S140|6.1.1|0x20001628|0x26000|
|S140|7.0.0|0x20001678|0x27000|
|S212|4.0.2|0x20000A80|0x12000|
|S212|5.0.0|0x20000B80|0x12000|
|S212|6.1.1|0x20000B80|0x12000|
|S312|6.1.1|0x20001300|0x24000|
|S332|4.0.2|0x20001E30|0x29000|
|S332|5.0.0|0x20001F30|0x2D000|
|S332|6.1.1|0x20002000|0x30000|
|S340|6.1.1|0x20002000|0x31000|
*Table 1*: Different start addresses for RAM and FLASH memory

## Addresses for the ARM GCC Compiler
The ARM GCC Compiler uses a linker file to store the RAM and FLASH memory addresses.

To edit the start and size of RAM and FLASH the GNU linker file:

1. Open the <project_name>_gcc_nrf52.ld file found in the armgcc folder in your preferred editor.

2. Located in the linker file is the following code, you have to modify:
   - FLASH (rx) : ORIGIN = is the FLASH start address, and LENGTH = sets the size of FLASH
   - RAM (rwx) :  ORIGIN = is the RAM start address, and LENGTH = sets the size of RAM

3. Save the file after you have modified it.

### Example with MBR
```
MEMORY
{
  FLASH (rx) : ORIGIN = 0x1000, LENGTH = 0xff000
  RAM (rwx) :  ORIGIN = 0x20000008, LENGTH = 0x3fff8
}
```
