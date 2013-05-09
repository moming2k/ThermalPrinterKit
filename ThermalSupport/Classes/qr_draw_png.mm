#include "qr_draw_png.h"
#include "zlib.h"

//=============================================================================
// QRDrawPNG::draw
//=============================================================================
int QRDrawPNG::draw(char *filename, int modulesize, int symbolsize,
              unsigned char data[MAX_MODULESIZE][MAX_MODULESIZE], void *opt)
{
	setup(filename, modulesize, symbolsize);
	
	/* ニ値イメージの構築 */
	if( this->raster(data) ) return(1);
	
	/* PNG書き出し */
	if( this->write() ) return(1);
	
	return(0);
}

//=================================================================================
// QRDrawPNG::create_image
//=================================================================================
int QRDrawPNG::raster(unsigned char data[MAX_MODULESIZE][MAX_MODULESIZE])
{
	int bitw = (int)ceil(this->rsize/8) + 1;
	
	/* 実際にデータを置く領域を確保 */
	bit_image = (unsigned char **)malloc(sizeof(unsigned char *) * this->rsize);
	for(int i=0; i<this->rsize; i++){
		bit_image[i] = (unsigned char *)malloc(bitw);
		memset(bit_image[i], 0, bitw);
	}

	for(int i=0; i<this->ssize; i++){
		int dp  = MARGIN_SIZE*this->msize / 8;			//横方向のバイト位置
		int sht =(MARGIN_SIZE*this->msize % 8) ? 3 : 7;	//ビットシフト
		unsigned char c = 0;							//1バイトの構成を保存
		
		for(int j=0; j<this->ssize; j++){
			/* 1行分生成 */
			for(int k=0; k<this->msize; k++){
				c += (data[j][i] << sht);
				sht--;
				
				bit_image[(i+MARGIN_SIZE)*this->msize][ dp ] = c;
				
				if(sht < 0){
					sht = 7;
					c   = 0;
					dp++;
				}
			}
		}
		/* モジュールサイズ分縦方向に増やす */
		for(int k=1; k<this->msize; k++){
			memcpy(bit_image[(i+MARGIN_SIZE)*this->msize+k], bit_image[(i+MARGIN_SIZE)*this->msize], bitw);
		}
	}

	return(0);

}

//=================================================================================
// QRDrawPNG::write
//=================================================================================
int QRDrawPNG::write()
{
	png_structp png_ptr;
	png_infop   info_ptr;
	FILE *stream;
	
	/* 出力先設定 */
	if(!this->filename){
		stream = stdout;
	}else{
		if( (stream=fopen(this->filename, "wb")) == NULL ) return(1);
	}
	
	png_ptr  = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
	info_ptr = png_create_info_struct(png_ptr);
	
	png_init_io(png_ptr, stream);
	png_set_filter(png_ptr, 0, PNG_ALL_FILTERS);
	png_set_compression_level(png_ptr, Z_BEST_COMPRESSION);
	png_set_invert_mono(png_ptr);	//白黒反転
	
	/* IHDRチャンク情報を設定 */
	png_set_IHDR(png_ptr, 						//png_structp
				 info_ptr, 						//png_infop
				 this->rsize,					//width
				 this->rsize, 					//height
				 1, 							//bit_depth(ニ値)
				 PNG_COLOR_TYPE_GRAY, 			//Colorタイプ(ニ値)
				 PNG_INTERLACE_NONE, 			//interlace_method
				 PNG_COMPRESSION_TYPE_DEFAULT, 	//compression_method
				 PNG_FILTER_TYPE_DEFAULT);		//filter_method

	png_write_info(png_ptr, info_ptr);
	png_write_image(png_ptr, bit_image);
	png_write_end(png_ptr, info_ptr);
	
	png_destroy_info_struct(png_ptr, &info_ptr);
	png_destroy_write_struct(&png_ptr, &info_ptr);
	
	fclose(stream);
	return(0);
}
