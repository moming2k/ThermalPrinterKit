#ifndef _QR_DRAW_PNG_
#define _QR_DRAW_PNG_

#include <stdlib.h>
#include <math.h>
#include "qr_draw.h"
#include "png.h"

//=============================================================================
// QRDrawPNG ƒNƒ‰ƒX
//=============================================================================
class QRDrawPNG : public QRDraw
{
	private:
		int raster(unsigned char data[MAX_MODULESIZE][MAX_MODULESIZE]);
		int write();
	
	public:
		QRDrawPNG(){}
		~QRDrawPNG(){}
		int draw(char *filename, int modulesize, int symbolsize,
                      unsigned char data[MAX_MODULESIZE][MAX_MODULESIZE], void *opt);
};

#endif
