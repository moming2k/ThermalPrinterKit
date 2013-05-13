#ifndef _QR_DRAW_
#define _QR_DRAW_

#define MARGIN_SIZE      4	/* マージンサイズ */
#define MAX_MODULESIZE 177	/* データバイト列の領域サイズ */

//=============================================================================
// QRDraw クラス
//=============================================================================
class QRDraw
{
	public:
		QRDraw(){
			this->bit_image=NULL;
		}
		
		virtual ~QRDraw(){
			this->close();
		}
		
		void setup(char *filename, int modulesize, int symbolsize){
			this->msize = modulesize;
			this->ssize = symbolsize;
			this->rsize = (this->ssize + MARGIN_SIZE * 2) * this->msize;
			this->filename = filename;
		}
		
	protected:
		unsigned char **bit_image;	//ピクセルイメージを格納する
		int msize;					// 1ドットを表現するピクセル数(=modulesize)
		int rsize;					// マージンを含めた実際のイメージの一辺
		int ssize;					// シンボルサイズ(マージンを含めない、ドットの個数)
		char *filename;				// 保存するファイル名

	public:
		virtual int draw(char *filename, int modulesize, int symbolsize, 
							unsigned char data[MAX_MODULESIZE][MAX_MODULESIZE], void *opt) = 0;
		void close(){
			int i;
			if(this->bit_image){
				for(i=0; i<this->rsize; i++) free(this->bit_image[i]);
				free(this->bit_image);
			}
			this->bit_image=NULL;
		}
};

#endif
