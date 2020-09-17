#ifndef __SETTING_H_
#define __SETTING_H_

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <time.h>

#define K 1024
#define M (1024*K)
#define G (1024L * M)

#define LEFTROTATE(x, c) (((x) << (c)) | ((x) >> (32 - (c))))

#define GIGAUNIT 16L
#define L_DEVICE ((GIGAUNIT * G))



#define OPAREA (L_DEVICE * 0.07)
#define R_DEVICE (L_DEVICE + OPAREA)

#define PAGESIZE (4*K)

#define LSB_RANGE 9

#define RANGE (L_DEVICE / PAGESIZE)

#define _PPB (1<<LSB_RANGE)

#define _NOB ceil(R_DEVICE / (_PPB * PAGESIZE))
#define _NOP (_NOB*_PPB)

#define HASHFTL 0
#define ZFTL    1


//Module setting
#define FIRST  1
#define SECOND 0


#endif
