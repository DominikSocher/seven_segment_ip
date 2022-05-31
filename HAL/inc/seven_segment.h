/*
 * seven_segment.h
 *
 *  Created on: 30.03.2021
 *      Author: Dominik
 *      Header file for seven segment driver
 */

#ifndef SEVEN_SEGMENT_H_
#define SEVEN_SEGMENT_H_

#include <alt_types.h>
#include <system.h>
#include <io.h>
/*
 * *****************************************************
 * Public function prototypes
 * *****************************************************
 */

void seven_segment_init(void);
void seven_segment_on(void);
void seven_segment_on(void);
void seven_segment_test_on(void);
void seven_segment_test_on(void);
void seven_segment_clear(void);
void display_char(alt_u8 digit, alt_u8 character);

#endif /* SEVEN_SEGMENT_H_ */

