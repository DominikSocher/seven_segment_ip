/*
 * seven_segment.c
 *
 *  Created on: 30.03.2021
 *      Author: Dominik
 */

#include "seven_segment.h"

/*
 * *********************************************************
 * Constants
 * *********************************************************
 */
#define shutdown_on 0x00
#define shutdown_off 0x01
#define self_test_on 0xf9
#define self_test_off 0x08
#define display_1 0x11
#define display_2 0x21
#define display_3 0x41
#define display_all 0xf1

/*
 * *********************************************************
 * Private Function Prototypes
 * *********************************************************
 */
static void segment_write(alt_u8 reg_number, alt_u8 data);

/*
 * *********************************************************
 * segment_write()
 *
 * Description: Write to seven segment device
 * Arguments  : reg_number = Register to write data
 *      	    data = data to write to device
 * Returns    : none
 *
 * *********************************************************
 */
static void segment_write(alt_u8 reg_number, alt_u8 data)
{
	alt_u32 data_send = 0;
	alt_u16 fill = 0x0000;
	//combine input parameters to 32 bit long
	data_send = (reg_number << 24) | (data << 16) | fill;
	//write to register
	IOWR_32DIRECT(SEVEN_SEG_IP_0_BASE, 4, data_send);
	//printf("data %x\n", data_send);
}

/*
 * *********************************************************
 * seven_segment_init
 *
 * Description: Initialize the seven segment device
 * Arguments  : none
 * Returns    : none
 *
 * *********************************************************
 */
void seven_segment_init(void)
{
	//activate display
	seven_segment_on();
	//start self test
	seven_segment_test_on();
	seven_segment_test_off();
	//clear display
	seven_segment_clear();
	seven_segment_off();
	seven_segment_on();
}

/*
 * *********************************************************
 * seven_segment_on()
 *
 * Description: Activate seven segment device
 * Arguments  : none
 * Returns    : none
 *
 * *********************************************************
 */
void seven_segment_on(void)
{
	segment_write(shutdown_off, 0);
}

/*
 * *********************************************************
 * seven_segment_off()
 *
 * Description: deactivate seven segment device
 * Arguments  : none
 * Returns    : none
 *
 * *********************************************************
 */
void seven_segment_off(void)
{
	segment_write(shutdown_on, 0);
}

/*
 * *********************************************************
 * seven_segment_test_on()
 *
 * Description: starts selftest
 * Arguments  : none
 * Returns    : none
 *
 * *********************************************************
 */
void seven_segment_test_on(void)
{
	segment_write(self_test_on, 0);
}

/*
 * *********************************************************
 * seven_segment_test_off()
 *
 * Description: stops selftest
 * Arguments  : none
 * Returns    : none
 *
 * *********************************************************
 */
void seven_segment_test_off(void)
{
	segment_write(self_test_off, 0);
}

/*
 * *********************************************************
 * seven_segment_clear()
 *
 * Description: clears all displays
 * Arguments  : none
 * Returns    : none
 *
 * *********************************************************
 */
void seven_segment_clear(void)
{
	segment_write(display_all, 0);
}

/*
 * *********************************************************
 * display char
 *
 * Description: clears all displays
 * Arguments  : digit     = digit number (1-4)
 *              character = character to display (0-9)
 * Returns    : none
 *
 * *********************************************************
 */
void display_char(alt_u8 digit, alt_u8 character)
{
	switch (digit)
	{
	case 1:
		segment_write(display_1, character);
		break;
	case 2:
		segment_write(display_2, character);
		break;
	case 3:
		segment_write(display_3, character);
		break;
	case 4:
		segment_write(display_all, character);
		break;
	default:
		break;
	}
}

