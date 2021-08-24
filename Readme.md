# 4 bit High Speed Domino Comparator (dvsd_cmp) RTL2GDS flow using SKY130 pdks
*The purpose of this project is to produce clean GDS (Graphic Design System) Final Layout with all details that is used to print photomasks used in fabrication of a behavioral RTL (Register-Transfer Level) of a 4 bit High Speed Domino Comparator, using SkyWater 130 nm PDK (Process Design Kit)*

# Table of Contents

- [Design Overview](#design-overview)
- [IP specs Provided](#ip-specs-provided)
- [Verilog behavioral design](#verilog-behavioral-design)
	- [Simulation](#simulation)
- [OpenLane](#openlane)
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
