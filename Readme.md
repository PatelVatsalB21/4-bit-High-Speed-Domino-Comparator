# 4 bit High Speed Domino Comparator (dvsd_cmp) RTL2GDS flow using SKY130 pdks
*The purpose of this project is to produce clean GDS (Graphic Design System) Final Layout with all details that is used to print photomasks used in fabrication of a behavioral RTL (Register-Transfer Level) of a 4 bit High Speed Domino Comparator, using SkyWater 130 nm PDK (Process Design Kit)*

# Table of Contents

- [Design Overview](#design-overview)
- [IP specs Provided](#ip-specs-provided)
- [Verilog behavioral design](#verilog-behavioral-design)
	- [Simulation](#simulation)
- [OpenLane](#openlane)
	- [Design Stages](#openLane-design-stages)	
	- [Installation](#installation)
	- [Running OpenLane](#running-openlane)
- [Synthesis](#synthesis)
- [Floorplanning](#floorplanning)
- [Placement](#placement)
- [Routing](#routing)
- [Layout vs Schematic](#layout-vs-schematic)
- [Final Layout](#final-layout)
- [Post-layout](#post-layout)
	- [Simulation](#simulation)
- [Steps to reproduce and explore the design](#steps-to-reproduce-and-explore-the-design)
- [Key points to Remember](#key-points-to-remember)
- [Area of improvement](#area-of-improvement)
- [References](#references)
- [Contributors](#contributors)

## Design Overview

<img src="https://github.com/PatelVatsalB21/High_Speed_Domino_Comparator/blob/main/images/application.png"/>

## IP specs

<img src="https://github.com/PatelVatsalB21/High_Speed_Domino_Comparator/blob/main/images/ip_specs.png"/>

## Verilog behavioral design

Yosys synthesis

<img src="https://github.com/PatelVatsalB21/High_Speed_Domino_Comparator/blob/main/images/yosys_flow.png"/>

## OpenLane 

OpenLane is an automated RTL to GDSII flow based on several components including OpenROAD, Yosys, Magic, Netgen, Fault and custom methodology scripts for design exploration and optimization.
For more information check [here](https://openlane.readthedocs.io/)

<img src="https://github.com/PatelVatsalB21/High_Speed_Domino_Comparator/blob/main/images/openlane_flow.png"/>

### OpenLane design stages

1. Synthesis
	- `yosys` - Performs RTL synthesis
	- `abc` - Performs technology mapping
	- `OpenSTA` - Performs static timing analysis on the resulting netlist to generate timing reports
2. Floorplan and PDN
	- `init_fp` - Defines the core area for the macro as well as the rows (used for placement) and the tracks (used for routing)
	- `ioplacer` - Places the macro input and output ports
	- `pdn` - Generates the power distribution network
	- `tapcell` - Inserts welltap and decap cells in the floorplan
3. Placement
	- `RePLace` - Performs global placement
	- `Resizer` - Performs optional optimizations on the design
	- `OpenDP` - Perfroms detailed placement to legalize the globally placed components
4. CTS
	- `TritonCTS` - Synthesizes the clock distribution network (the clock tree)
5. Routing
	- `FastRoute` - Performs global routing to generate a guide file for the detailed router
	- `CU-GR` - Another option for performing global routing.
	- `TritonRoute` - Performs detailed routing
	- `SPEF-Extractor` - Performs SPEF extraction
6. GDSII Generation
	- `Magic` - Streams out the final GDSII layout file from the routed def
	- `Klayout` - Streams out the final GDSII layout file from the routed def as a back-up
7. Checks
	- `Magic` - Performs DRC Checks & Antenna Checks
	- `Klayout` - Performs DRC Checks
	- `Netgen` - Performs LVS Checks
	- `CVC` - Performs Circuit Validity Checks
