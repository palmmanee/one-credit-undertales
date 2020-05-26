##--------------------------------------------------
## Constraints Module : Digilent Basys 3               
## BeeInvaders Tutorial 3 : Onboard clock 100MHz
## VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
##--------------------------------------------------

## Clock
set_property -dict {PACKAGE_PIN W5  IOSTANDARD LVCMOS33} [get_ports {CLK}];
create_clock -add -name sys_clk_pin -period 10.00 \
    -waveform {0 5} [get_ports {CLK}];

##Buttons : Use BTNC as Reset Button (active high)
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {RESET}];
set_property PACKAGE_PIN W19 [get_ports btnL]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnL]
set_property PACKAGE_PIN T17 [get_ports btnR]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnR]
set_property PACKAGE_PIN T18 [get_ports btnU]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnU]
set_property PACKAGE_PIN U17 [get_ports btnD]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnD]

## VGA Connector
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports {RED[0]}];
set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports {RED[1]}];
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports {RED[2]}];
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS33} [get_ports {RED[3]}];
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports {BLUE[0]}];
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports {BLUE[1]}];
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports {BLUE[2]}];
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {BLUE[3]}];
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports {GREEN[0]}];
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {GREEN[1]}];
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {GREEN[2]}];
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports {GREEN[3]}];
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports {HSYNC}];
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports {VSYNC}];

##USB-RS232 Interface
#set_property PACKAGE_PIN B18 [get_ports RsRx]						
	#set_property IOSTANDARD LVCMOS33 [get_ports RsRx]
set_property PACKAGE_PIN A18 [get_ports tx]						
	set_property IOSTANDARD LVCMOS33 [get_ports tx]


#USB HID (PS/2)
set_property PACKAGE_PIN C17 [get_ports PS2Clk]						
	set_property IOSTANDARD LVCMOS33 [get_ports PS2Clk]
	set_property PULLUP true [get_ports PS2Clk]
set_property PACKAGE_PIN B17 [get_ports PS2Data]					
	set_property IOSTANDARD LVCMOS33 [get_ports PS2Data]	
	set_property PULLUP true [get_ports PS2Data]
	
##7 segment display
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

set_property PACKAGE_PIN V7 [get_ports dp]
	set_property IOSTANDARD LVCMOS33 [get_ports dp]

set_property PACKAGE_PIN U2 [get_ports {an[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]


## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]