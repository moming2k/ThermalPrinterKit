//
//  Barcode.h
//  iOSKuapay
//
//  Created by Patrick Hogan on 12/5/11.
//  Copyright (c) 2011 Kuapay LLC. All rights reserved.
//

@class Barcode;

typedef enum
{
    CODE_128,
    EAN_13
} OneDimCodeType;

typedef enum
{
    EAN8 = 8,
    EAN13 = 13
} BarcodeType;


@interface Barcode : NSObject <UIWebViewDelegate>
{
    NSArray *encoding, *first, *code128Encoding;
}

@property (nonatomic, retain) UIImage *oneDimBarcode;
@property (nonatomic, retain) UIImage *qRBarcode;

@property (nonatomic, copy) NSString *oneDimCode;

-(void)setupBarcodes:(NSString *)code;
-(void)setupQRCode:(NSString *)code;
-(void)setupOneDimBarcode:(NSString *)code type:(OneDimCodeType)type;

@end
