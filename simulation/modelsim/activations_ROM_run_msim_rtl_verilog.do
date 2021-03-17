transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/diegotf/Escritorio/Addressing\ update\ 2/Adressing/Addressing/verilog/Act_Functions {/home/diegotf/Escritorio/Addressing update 2/Adressing/Addressing/verilog/Act_Functions/core.v}
vlog -vlog01compat -work work +incdir+/home/diegotf/Escritorio/Addressing\ update\ 2/Adressing/Addressing/verilog/Act_Functions {/home/diegotf/Escritorio/Addressing update 2/Adressing/Addressing/verilog/Act_Functions/fixed32_to_fp32.v}
vlog -vlog01compat -work work +incdir+/home/diegotf/Escritorio/Addressing\ update\ 2/Adressing/Addressing/verilog/Act_Functions {/home/diegotf/Escritorio/Addressing update 2/Adressing/Addressing/verilog/Act_Functions/pipe_signals.v}
vlog -vlog01compat -work work +incdir+/home/diegotf/Escritorio/Addressing\ update\ 2/Adressing/Addressing/verilog/Act_Functions {/home/diegotf/Escritorio/Addressing update 2/Adressing/Addressing/verilog/Act_Functions/dual_port_rom.v}

