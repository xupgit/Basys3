#AXI IP Controller for WS2812 LED controller#

The WS2812 controller can drive LED chains using a single data line using a timing protocol. For more details on the WS2812, please see:
[WS2812.pdf](https://github.com/xupgit/Basys3/blob/master/Library/Interface/ws2812-LED-controller/WS2812.pdf) 

The IP has been created with Vivado 2015.2 and is provided in IP-XACT form, to work with Vivado IP Integrator. It can also be used in a non-IPI design.

LEDs can be controlled by writing data to the peripheral base address + the LED position in the chain. 

``e.g. The address for LED 1 is (Base address + 1). Data is written as 24-bit GRB (Green-Red-Blue).``

###Parameters###
Number of LEDs in the chain is parameterizable. (The WS2812 controller is a serial interface and can be used to control long chains of LEDs connected together in series.)


Clock frequency of between 50 – 250 MHz is selectable. This should be chosen to match the incoming AXI clock.


The ADDR Width will be automatically calculated based on the number of LEDs. 

`e.g. (ADDR Width = log2(LEDs) + 2 for 32 bit or +3 for 64 bit).`

###Data Format###
24-bit Data should be written to the IP in Green, Red, Blue order from MSB -> LSB
23 - 16 MSB Green LSB 
15 - 	8 MSB Red LSB
 7 -  0 MSB Blue	LSB
		 	
``e.g. Writing 0xff3f03 ``

    Green = 0xff (Intensity = 255)
    
    Red   = 0x3f (intensity =  63)
    
    Blue  = 0x0f (intensity =  15)

### Addressing LED positions ###
    LED 0	(Base address)		
    
    LED 1	(Base address + 1) 	
    
    etc.
    
### Tool and device details###
This IP has been tested with Vivado 2015.2, the Digilent Basys 3 (Xilinx Artix device), and an ADAfruit 16 LED Neopixel Ring but should work on other series 7 Xilinx FPGAs (Artix, Kintex, Virtex and Zynq) and other WS2812/Adafruit LED strips, rings, with the WS2812 controller. 
