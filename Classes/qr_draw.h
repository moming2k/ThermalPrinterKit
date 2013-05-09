#ifndef _QR_DRAW_
#define _QR_DRAW_

#define MARGIN_SIZE      4	/* �}�[�W���T�C�Y */
#define MAX_MODULESIZE 177	/* �f�[�^�o�C�g��̗̈�T�C�Y */

//=============================================================================
// QRDraw �N���X
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
		unsigned char **bit_image;	//�s�N�Z���C���[�W���i�[����
		int msize;					// 1�h�b�g��\������s�N�Z����(=modulesize)
		int rsize;					// �}�[�W�����܂߂����ۂ̃C���[�W�̈��
		int ssize;					// �V���{���T�C�Y(�}�[�W�����܂߂Ȃ��A�h�b�g�̌�)
		char *filename;				// �ۑ�����t�@�C����

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
