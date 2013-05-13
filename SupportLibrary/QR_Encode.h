//---(1)��������-------------------------
//// QR_Encode.h : CQR_Encode �N���X�錾����уC���^�[�t�F�C�X��`
//// Date 2006/05/17	Ver. 1.12 [Class Ver.1.22] Psytec Inc.
//
//#if !defined(AFX_QR_ENCODE_H__AC886DF7_C0AE_4C9F_AC7A_FCDA8CB1DD37__INCLUDED_)
//#define AFX_QR_ENCODE_H__AC886DF7_C0AE_4C9F_AC7A_FCDA8CB1DD37__INCLUDED_
//
//#if _MSC_VER > 1000
//#pragma once
//#endif // _MSC_VER > 1000
//---(1)�����܂ł��R�����g�A�E�g-----------

//---(2)��������-----------
#ifndef __QR_ENCODER__
#define __QR_ENCODER__
#include "win2ansi.h"
//---(2)�����܂ł�ǉ�-----------

/////////////////////////////////////////////////////////////////////////////
// �萔

// ���������x��
#define QR_LEVEL_L	0
#define QR_LEVEL_M	1
#define QR_LEVEL_Q	2
#define QR_LEVEL_H	3

// �f�[�^���[�h
#define QR_MODE_NUMERAL		0
#define QR_MODE_ALPHABET	1
#define QR_MODE_8BIT		2
#define QR_MODE_KANJI		3

// �o�[�W����(�^��)�O���[�v
#define QR_VRESION_S	0 // 1 �` 9
#define QR_VRESION_M	1 // 10 �` 26
#define QR_VRESION_L	2 // 27 �` 40

#define MAX_ALLCODEWORD	 3706 // ���R�[�h���[�h���ő�l
#define MAX_DATACODEWORD 2956 // �f�[�^�R�[�h���[�h�ő�l(�o�[�W����40-L)
#define MAX_CODEBLOCK	  153 // �u���b�N�f�[�^�R�[�h���[�h���ő�l(�q�r�R�[�h���[�h���܂�)
#define MAX_MODULESIZE	  177 // ��Ӄ��W���[�����ő�l

// �r�b�g�}�b�v�`�掞�}�[�W��
#define QR_MARGIN	4


/////////////////////////////////////////////////////////////////////////////
typedef struct tagRS_BLOCKINFO
{
	int ncRSBlock;		// �q�r�u���b�N��
	int ncAllCodeWord;	// �u���b�N���R�[�h���[�h��
	int ncDataCodeWord;	// �f�[�^�R�[�h���[�h��(�R�[�h���[�h�� - �q�r�R�[�h���[�h��)

} RS_BLOCKINFO, *LPRS_BLOCKINFO;


/////////////////////////////////////////////////////////////////////////////
// QR�R�[�h�o�[�W����(�^��)�֘A���

typedef struct tagQR_VERSIONINFO
{
	int nVersionNo;	   // �o�[�W����(�^��)�ԍ�(1�`40)
	int ncAllCodeWord; // ���R�[�h���[�h��

	// �ȉ��z��Y���͌�������(0 = L, 1 = M, 2 = Q, 3 = H) 
	int ncDataCodeWord[4];	// �f�[�^�R�[�h���[�h��(���R�[�h���[�h�� - �q�r�R�[�h���[�h��)

	int ncAlignPoint;	// �A���C�����g�p�^�[�����W��
	int nAlignPoint[6];	// �A���C�����g�p�^�[�����S���W

	RS_BLOCKINFO RS_BlockInfo1[4]; // �q�r�u���b�N���(1)
	RS_BLOCKINFO RS_BlockInfo2[4]; // �q�r�u���b�N���(2)

} QR_VERSIONINFO, *LPQR_VERSIONINFO;


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode �N���X

class CQR_Encode
{
// �\�z/����
public:
	CQR_Encode();
	~CQR_Encode();

public:
	int m_nLevel;		// ���������x��
	int m_nVersion;		// �o�[�W����(�^��)
	QRBOOL m_bAutoExtent;	// �o�[�W����(�^��)�����g���w��t���O
	int m_nMaskingNo;	// �}�X�L���O�p�^�[���ԍ�

public:
	int m_nSymbleSize;
	BYTE m_byModuleData[MAX_MODULESIZE][MAX_MODULESIZE]; // [x][y]
	// bit5:�@�\���W���[���i�}�X�L���O�ΏۊO�j�t���O
	// bit4:�@�\���W���[���`��f�[�^
	// bit1:�G���R�[�h�f�[�^
	// bit0:�}�X�N��G���R�[�h�`��f�[�^
	// 20h�Ƃ̘_���a�ɂ��@�\���W���[������A11h�Ƃ̘_���a�ɂ��`��i�ŏI�I�ɂ�QRBOOL�l���j

private:
	int m_ncDataCodeWordBit; // �f�[�^�R�[�h���[�h�r�b�g��
	BYTE m_byDataCodeWord[MAX_DATACODEWORD]; // ���̓f�[�^�G���R�[�h�G���A

	int m_ncDataBlock;
	BYTE m_byBlockMode[MAX_DATACODEWORD];
	int m_nBlockLength[MAX_DATACODEWORD];

	int m_ncAllCodeWord; // ���R�[�h���[�h��(�q�r�������f�[�^���܂�)
	BYTE m_byAllCodeWord[MAX_ALLCODEWORD]; // ���R�[�h���[�h�Z�o�G���A
	BYTE m_byRSWork[MAX_CODEBLOCK];	// �q�r�R�[�h���[�h�Z�o���[�N

// �f�[�^�G���R�[�h�֘A�t�@���N�V����
public:
	QRBOOL EncodeData(int nLevel, int nVersion, QRBOOL bAutoExtent, int nMaskingNo, LPCSTR lpsSource, int ncSource = 0);

private:
	int GetEncodeVersion(int nVersion, LPCSTR lpsSource, int ncLength);
	QRBOOL EncodeSourceData(LPCSTR lpsSource, int ncLength, int nVerGroup);

	int GetBitLength(BYTE nMode, int ncData, int nVerGroup);

	int SetBitStream(int nIndex, WORD wData, int ncData);

	QRBOOL IsNumeralData(unsigned char c);
	QRBOOL IsAlphabetData(unsigned char c);
	QRBOOL IsKanjiData(unsigned char c1, unsigned char c2);

	BYTE AlphabetToBinaly(unsigned char c);
	WORD KanjiToBinaly(WORD wc);

	void GetRSCodeWord(LPBYTE lpbyRSWork, int ncDataCodeWord, int ncRSCodeWord);

// ���W���[���z�u�֘A�t�@���N�V����
private:
	void FormatModule();

	void SetFunctionModule();
	void SetFinderPattern(int x, int y);
	void SetAlignmentPattern(int x, int y);
	void SetVersionPattern();
	void SetCodeWordPattern();
	void SetMaskingPattern(int nPatternNo);
	void SetFormatInfoPattern(int nPatternNo);
	int CountPenalty();
};

/////////////////////////////////////////////////////////////////////////////

#endif // !defined(AFX_QR_ENCODE_H__AC886DF7_C0AE_4C9F_AC7A_FCDA8CB1DD37__INCLUDED_)
