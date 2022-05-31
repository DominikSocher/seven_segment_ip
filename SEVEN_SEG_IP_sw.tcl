create_driver seven_segement driver
set_sw_property hw_class_name SEVEN_SEG_IP
set_sw_property version 1
set_sw_property min_compatible_hw_version 1.0
add_sw_property bsp_subdirectory drivers
add_sw_property c_source HAL/src/seven_segment.c
add_sw_property include_source HAL/inc/seven_segment.h
add_sw_property supported_bsp_type HAL