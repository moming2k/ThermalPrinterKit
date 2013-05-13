#ifndef __WIN32_TO_ANSI__
#define __WIN32_TO_ANSI__

#include <string.h>
#include <stdlib.h>

typedef bool            QRBOOL;
typedef unsigned char   BYTE;
typedef unsigned short  WORD;
typedef char*           LPCSTR;
typedef unsigned char * LPBYTE;

#define QRTRUE  true
#define QRFALSE false

#define lstrlen strlen
#define ZeroMemory(x, y) memset(x, 0, y)
#define min(x, y) x < y ? x : y

#endif
