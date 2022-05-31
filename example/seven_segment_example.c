/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include <system.h>
#include "seven_segment.h"

int main()
{
	printf("Hello from Nios II!\n");
	seven_segment_init();

	alt_u8 a = 20;
	alt_u8 b = 33;
	alt_u8 c = 99;
	alt_u8 d = 2;

	while (1) {
		display_char(4,a);
		for(size_t i = 0; i < 500000; i++);
		display_char(3,b+d);
		for(size_t i = 0; i < 500000; i++);
		display_char(1,c);
		for(size_t i = 0; i < 500000; i++);
		display_char(2,d);
		for(size_t i = 0; i < 500000; i++);
	}
return 0;
}
