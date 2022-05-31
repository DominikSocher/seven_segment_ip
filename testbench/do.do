transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/Dominik/Documents/TEIS/ip_projects/seven_segment_ip/seven_segment_controller.vhd}
vcom -93 -work work {C:/Users/Dominik/Documents/TEIS/ip_projects/seven_segment_ip/display_driver.vhd}
vcom -93 -work work {C:/Users/Dominik/Documents/TEIS/ip_projects/seven_segment_ip/seven_segment_decoder.vhd}
vcom -93 -work work {C:/Users/Dominik/Documents/TEIS/ip_projects/seven_segment_ip/binary_to_bcd_digit.vhd}
vcom -93 -work work {C:/Users/Dominik/Documents/TEIS/ip_projects/seven_segment_ip/binary_to_bcd.vhd}
vcom -93 -work work {C:/Users/Dominik/Documents/TEIS/ip_projects/seven_segment_ip/seven_segment_ip.vhd}

vcom -93 -work work {C:/Users/Dominik/Documents/TEIS/ip_projects/seven_segment_ip/simulation/modelsim/seven_segment_ip.vht}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  seven_segment_ip_vhd_tst

add wave -noupdate -divider TOP
add wave -position insertpoint sim:/seven_segment_ip_vhd_tst/*
add wave -noupdate -divider DISPLAY_DRIVER
add wave -position insertpoint sim:/seven_segment_ip_vhd_tst/i1/*
add wave -noupdate -divider DISPLAY_CONTROLLER
add wave -position insertpoint sim:/seven_segment_ip_vhd_tst/i1/display_inst/controller_inst/*
add wave -noupdate -divider BCD_A
add wave -position insertpoint sim:/seven_segment_ip_vhd_tst/i1/display_inst/binary_to_bcd_inst_a/*
add wave -noupdate -divider display_0
add wave -position insertpoint sim:/seven_segment_ip_vhd_tst/i1/display_inst/u0/*
add wave -noupdate -divider display_1
add wave -position insertpoint sim:/seven_segment_ip_vhd_tst/i1/display_inst/u1/*
add wave -noupdate -divider BCD_B
add wave -position insertpoint sim:/seven_segment_ip_vhd_tst/i1/display_inst/binary_to_bcd_inst_b/*
add wave -noupdate -divider display_2
add wave -position insertpoint sim:/seven_segment_ip_vhd_tst/i1/display_inst/u2/*
add wave -noupdate -divider display_3
add wave -position insertpoint sim:/seven_segment_ip_vhd_tst/i1/display_inst/u3/*
add wave -noupdate -divider BCD_C
add wave -position insertpoint sim:/seven_segment_ip_vhd_tst/i1/display_inst/binary_to_bcd_inst_c/*
add wave -noupdate -divider display_4
add wave -position insertpoint sim:/seven_segment_ip_vhd_tst/i1/display_inst/u4/*
add wave -noupdate -divider display_5
add wave -position insertpoint sim:/seven_segment_ip_vhd_tst/i1/display_inst/u5/*

view structure
view signals
run -all
