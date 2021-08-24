# 4 bit High Speed Domino Comparator (dvsd_cmp) RTL2GDS flow using SKY130 pdks
*The purpose of this project is to produce clean GDS (Graphic Design System) Final Layout with all details that is used to print photomasks used in fabrication of a behavioral RTL (Register-Transfer Level) of a 4 bit High Speed Domino Comparator, using SkyWater 130 nm PDK (Process Design Kit)*

# Table of Contents

- [Design Overview](#design-overview)
- [IP specs Provided](#ip-specs)
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

### Installation

#### Prerequisites

- Preferred Ubuntu OS)
- Docker 19.03.12+
- GNU Make
- Python 3.6+ with PIP
- Click, Pyyaml: `pip3 install pyyaml click`

```
git clone https://github.com/The-OpenROAD-Project/OpenLane.git
cd OpenLane/
make openlane
make pdk
make test # This a ~5 minute test that verifies that the flow and the pdk were properly installed
```

For detailed installation process, check [here](https://github.com/The-OpenROAD-Project/OpenLane)

### Running OpenLane

`make mount`
- Note
	- Default PDK_ROOT is $(pwd)/pdks. If you have installed the PDK at a different location, run the following before `make mount`:
	- Default IMAGE_NAME is efabless/openlane:current. If you want to use a different version, run the following before `make mount`:

The following is roughly what happens under the hood when you run `make mount` + the required exports:

```
export PDK_ROOT=<absolute path to where skywater-pdk and open_pdks will reside>
export IMAGE_NAME=<docker image name>
docker run -it -v $(pwd):/openLANE_flow -v $PDK_ROOT:$PDK_ROOT -e PDK_ROOT=$PDK_ROOT -u $(id -u $USER):$(id -g $USER) $IMAGE_NAME
```

You can use the following example to check the overall setup:

`./flow.tcl -design spm`

To run openlane in interactive mode

`./flow.tcl -interactive`

<img src="https://github.com/PatelVatsalB21/High_Speed_Domino_Comparator/blob/main/images/openlane_interactive.png"/>

### Synthesis

Synthesis reports


```

- Printing statistics.

=== cmp ===

   Number of wires:                 11
   Number of wire bits:             17
   Number of public wires:           4
   Number of public wire bits:      10
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                  8
     $_ANDNOT_                       3
     $_OR_                           1
     $_XNOR_                         1
     $_XOR_                          3
```


```

- Printing statistics.

=== cmp ===

   Number of wires:                 10
   Number of wire bits:             16
   Number of public wires:           4
   Number of public wire bits:      10
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                  7
     sky130_fd_sc_hd__a2bb2o_2       4
     sky130_fd_sc_hd__a41o_2         1
     sky130_fd_sc_hd__inv_2          2

   Chip area for module '\cmp': 63.811200
   
```

- Yosys synthesis strategies

<img src="https://github.com/PatelVatsalB21/High_Speed_Domino_Comparator/blob/main/images/yosys.png"/>

### Floorplanning 


```

# User config
set ::env(DESIGN_NAME) cmp

# Change if needed
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]

# turn off clock
set ::env(CLOCK_TREE_SYNTH) 0
set ::env(CLOCK_PORT) ""

set ::env(PL_SKIP_INITIAL_PLACEMENT) 1
set ::env(PL_RANDOM_GLB_PLACEMENT) 0

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0.0 0.0 21.81 32.53"
set ::env(PL_TARGET_DENSITY) 0.6

set ::env(FP_HORIZONTAL_HALO) 6
set ::env(FP_VERTICAL_HALO) $::env(FP_HORIZONTAL_HALO)

set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}

```



<img src="https://github.com/PatelVatsalB21/High_Speed_Domino_Comparator/blob/main/images/floorplan.png"/>

### Placement

- Placement Analysis

```
---------------------------------
total displacement          0.0 u
average displacement        0.0 u
max displacement            0.0 u
original HPWL             306.6 u
legalized HPWL            313.3 u
delta HPWL                    2 %
```


- Routing resources analysis

```
          Routing      Original      Derated      Resource
Layer     Direction    Resources     Resources    Reduction (%)
---------------------------------------------------------------
li1        Vertical          180           115          36.11%
met1       Horizontal        240           171          28.75%
met2       Vertical          180           135          25.00%
met3       Horizontal        120            92          23.33%
met4       Vertical           72            55          23.61%
met5       Horizontal         24            16          33.33%
---------------------------------------------------------------
```

- Final congestion report

```

Layer         Resource        Demand        Usage (%)    Max H / Max V / Total Overflow
---------------------------------------------------------------------------------------
li1                115             4            3.48%             0 /  0 /  0
met1               171             9            5.26%             0 /  0 /  0
met2               135             3            2.22%             0 /  0 /  0
met3                92             0            0.00%             0 /  0 /  0
met4                55             0            0.00%             0 /  0 /  0
met5                16             0            0.00%             0 /  0 /  0
---------------------------------------------------------------------------------------
Total              584            16            2.74%             0 /  0 /  0
```

<img src="https://github.com/PatelVatsalB21/High_Speed_Domino_Comparator/blob/main/images/final%20gds.png"/>


### Routing

- Routing resurces analysis

```
          Routing      Original      Derated      Resource
Layer     Direction    Resources     Resources    Reduction (%)
---------------------------------------------------------------
li1        Vertical          300            64          78.67%
met1       Horizontal        400           301          24.75%
met2       Vertical          300           244          18.67%
met3       Horizontal        200           165          17.50%
met4       Vertical          120            94          21.67%
met5       Horizontal         40            30          25.00%
---------------------------------------------------------------
```

- Final congestion report

```
Layer         Resource        Demand        Usage (%)    Max H / Max V / Total Overflow
---------------------------------------------------------------------------------------
li1                 64             2            3.12%             0 /  0 /  0
met1               301            14            4.65%             0 /  0 /  0
met2               244            17            6.97%             0 /  0 /  0
met3               165             0            0.00%             0 /  0 /  0
met4                94             0            0.00%             0 /  0 /  0
met5                30             0            0.00%             0 /  0 /  0
---------------------------------------------------------------------------------------
Total              898            33            3.67%             0 /  0 /  0
```

- Complete detail routing

```
total wire length = 296 um
total wire length on LAYER li1 = 0 um
total wire length on LAYER met1 = 106 um
total wire length on LAYER met2 = 148 um
total wire length on LAYER met3 = 42 um
total wire length on LAYER met4 = 0 um
total wire length on LAYER met5 = 0 um
total number of vias = 91
up-via summary (total 91):

---------------------
 FR_MASTERSLICE     0
            li1    48
           met1    39
           met2     4
           met3     0
           met4     0
---------------------
                   91
```

#### Final Summary 

```
Run Directory: /openLANE_flow/OpenLane/cmp/runs/run_four
----------------------------------------

Magic DRC Summary:
Source: /openLANE_flow/OpenLane/cmp/runs/run_four/reports/magic//50-magic.drc
Violation Message "Metal5 spacing < 1.6um (met5.2) "found 56 Times.
Total Magic DRC violations is 56
----------------------------------------

LVS Summary:
Source: /openLANE_flow/OpenLane/cmp/runs/run_four/results/lvs/cmp.lvs_parsed.lef.log
LVS reports no net, device, pin, or property mismatches.
Total errors = 0
----------------------------------------

Antenna Summary:
Source: /openLANE_flow/OpenLane/cmp/runs/run_four/reports/routing//52-antenna.rpt
Number of pins violated: 0
Number of nets violated: 0
[INFO]: check full report here: /openLANE_flow/OpenLane/cmp/runs/run_four/reports/final_summary_report.csv
[INFO]: Saving Runtime Environment
[SUCCESS]: Flow Completed Without Fatal Errors.
```

### Final Layout

- Layout after floorplanning and placement in Magic

<img src="https://github.com/PatelVatsalB21/High_Speed_Domino_Comparator/blob/main/images/floorplan%20and%20placement.png"/>

- Final GDS layout

<img src="https://github.com/PatelVatsalB21/High_Speed_Domino_Comparator/blob/main/images/final%20gds.png"/>

- Closeup view of the final layout design

<img src="https://github.com/PatelVatsalB21/High_Speed_Domino_Comparator/blob/main/images/close%20gds.png"/>

- lef layout

<img src="https://github.com/PatelVatsalB21/High_Speed_Domino_Comparator/blob/main/images/lef%20layout.png"/>


## Post-layout

### Simulation

GTKWave output waveform

<img src="https://github.com/PatelVatsalB21/High_Speed_Domino_Comparator/blob/main/images/gls.png"/>


## Steps to reproduce and explore the design

- Clone the project using following command
 
`git clone https://github.com/PatelVatsalB21/High_Speed_Domino_Comparator.git`

- To explore synthesis of the design

```
make mount
flow.tcl -design cmp -synth_explore
```

- To explore floorplan

```
cd floorplan/
magic lef read merged.lef def read cmp.floorplan.def &
```

- To explore placement

```
cd placement/ 
magic lef read merged.lef def read cmp.placement.def &
```

- To explore final layout

```
cd final_layout/
magic cmp.mag
```

- To reproduce Post-layout simulation

```
cd post_layout/
iverilog -o gls gls.v primitives.v sky130_fd_sc_hd.v
./gls
gtkwave gls.vcd
```

- Complete details, logs and results can be found under this [folder](https://github.com/PatelVatsalB21/High_Speed_Domino_Comparator/tree/main/cmp). 

```
cmp
├── runs
│   ├── logs
│   │   ├── cts
│   │   ├── cvc
│   │   ├── floorplan
│   │   ├── klayout
│   │   ├── lvs
│   │   ├── magic
│   │   ├── placement
│   │   ├── routing
│   │   └── synthesis
│   ├── reports
│   │   ├── cts
│   │   ├── cvc
│   │   ├── floorplan
│   │   ├── klayout
│   │   ├── lvs
│   │   ├── magic
│   │   ├── placement
│   │   ├── routing
│   │   └── synthesis
│   ├── results
│   │   ├── cts
│   │   ├── cvc
│   │   ├── floorplan
│   │   ├── klayout
│   │   ├── lvs
│   │   ├── magic
│   │   ├── placement
│   │   ├── routing
│   │   └── synthesis
│   └── tmp
│       ├── cts
│       ├── cvc
│       ├── floorplan
│       ├── klayout
│       ├── lvs
│       ├── magic
│       ├── placement
│       ├── routing
│       └── synthesis
└── src
```

## Key points to Remember

- Keep the top module name and design name always, else errors would come in the design.
- This project is a Combinaional block hence there is no clock, static  time analysis is being skiped.
