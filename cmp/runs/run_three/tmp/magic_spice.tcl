
if { [info exist ::env(MAGIC_EXT_USE_GDS)] && $::env(MAGIC_EXT_USE_GDS) } {
	gds read $::env(CURRENT_GDS)
} else {
	lef read /openLANE_flow/pdks/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef
	if {  [info exist ::env(EXTRA_LEFS)] } {
		set lefs_in $::env(EXTRA_LEFS)
		foreach lef_file $lefs_in {
			lef read $lef_file
		}
	}
	def read /openLANE_flow/cmp/runs/run_three/results/routing/26-cmp.def
}
load cmp -dereference
cd /openLANE_flow/cmp/runs/run_three/results/magic/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
if { ! 0 } {
	extract unique
}
# extract warn all
extract

ext2spice lvs
ext2spice -o /openLANE_flow/cmp/runs/run_three/results/magic/cmp.spice cmp.ext
feedback save /openLANE_flow/cmp/runs/run_three/logs/magic/110-magic_ext2spice.feedback.txt
# exec cp cmp.spice /openLANE_flow/cmp/runs/run_three/results/magic/cmp.spice

