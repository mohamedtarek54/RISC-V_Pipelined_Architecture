onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /RISC_top_tb/u_top/clk
add wave -noupdate /RISC_top_tb/u_top/rst
add wave -noupdate /RISC_top_tb/u_top/u_data_path/u_pc/pc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {357 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 371
configure wave -valuecolwidth 98
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
configure wave -timelineunits ns
update
WaveRestoreZoom {200 ns} {400 ns}
