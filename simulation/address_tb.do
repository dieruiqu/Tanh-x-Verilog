onerror {resume}
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000001
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000002
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000003
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000004
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000005
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000006
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000007
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000008
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000009
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000010
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000011
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000012
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000013
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000014
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000015
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000016
quietly virtual function -install /address_tb -env /address_tb { 0.0000001} virtual_000017
quietly virtual function -install /address_tb -env /address_tb { 0.0009765625} virtual_000018
quietly virtual function -install /address_tb -env /address_tb { 0.0009765625} virtual_000019
quietly virtual function -install /address_tb -env /address_tb { 0.0009765625} virtual_000020
quietly virtual function -install /address_tb -env /address_tb { 0.0009765625} virtual_000021
quietly virtual function -install /address_tb -env /address_tb { 0.0009765625} virtual_000022
quietly virtual function -install /address_tb -env /address_tb { 0.0009765625} virtual_000023
quietly virtual function -install /address_tb -env /address_tb { 0.0009765625} virtual_000024
quietly virtual function -install /address_tb -env /address_tb { 0.0009765625} virtual_000025
quietly virtual function -install /address_tb -env /address_tb { 0.0009765625} virtual_000026
quietly WaveActivateNextPane {} 0
add wave -noupdate -label Clock /address_tb/clock
add wave -noupdate -label {Reset N} /address_tb/resetn
add wave -noupdate -color Red -label Mode /address_tb/modes
add wave -noupdate -label {Input Value} /address_tb/value_w
add wave -noupdate -expand -group Results -color Gold -format Analog-Step -height 110 -label GOLD -max 1.1000000000000001 -min -1.1000000000000001 /address_tb/gold
add wave -noupdate -expand -group Results -color Cyan -format Analog-Step -height 110 -label {FPGA Real} -max 1.1000000000000001 -min -1.1000000000000001 /address_tb/fpga
add wave -noupdate -expand -group Results -color Red -format Analog-Step -height 50 -label {ERROR: Max = 50E-6} -max 0.48557700000000009 -min -0.31310300000000002 /address_tb/error
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {227258538 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 307
configure wave -valuecolwidth 150
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {736842105 ps}
